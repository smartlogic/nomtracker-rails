require File.dirname(__FILE__) + '/../test_helper'

# custom shoulda macro
def should_require(att)
  should "require #{att}" do
    create_user(att => nil)
    assert assigns(:user).errors.on(att)
    assert_response :success
    assert_template 'new'
  end
end

class UsersControllerTest < ActionController::TestCase

  context "A user is ready to submit a form to create an account for an email that doesn't yet exist" do
    should_require :email
    should_require :password
    should_require :password_confirmation
    should_require :name
    
    context "the user submits a valid form" do
      setup do
        UserMailer.stubs(:deliver_signup_notification).returns(true).then.raises(StandardError)
        create_user
      end
      
      should "set the flash[:notice]" do
        assert_not_nil flash[:notice]
      end
      
      should "redirect to the site root" do
        assert_redirected_to root_path
      end
      
      should "place the user into the :pending user_state" do
        assert User.find_by_email('quire@example.com').pending?
      end
      
      should "assign the user an activation code" do
        assert_not_nil assigns(:user).reload.activation_code
      end
      
      should "trigger a signup confirmation email to the user which includes the URL to follow to activate the account" do
        assert_raises(StandardError) { UserMailer.deliver_signup_notification("blah") }
      end
      
    end
  end
  
  context "A pending account exists" do
    setup do
      @u = User.new(user_attrs)
      @u.user_state = 'pending'
      @u.save!
    end
    
    context "the user tries the activation URL with an invalid activation code" do
      setup do
        UserMailer.stubs(:deliver_activation).returns(true).then.raises(StandardError)
        get :activate, {:activation_code => "something it would never be"}
      end
      
      should "redirect to the root path" do
        assert_redirected_to root_path
      end
      
      should "set a flash[:error] message" do
        assert_not_nil flash[:error]
      end
      
      should "not activate the user" do
        assert @u.reload.pending?
      end
      
      should "not send an account activation email" do
        assert_nothing_raised { UserMailer.deliver_activation("blah") }
      end
    end
    
    context "the user tries the activation URL with a valid activation code" do
      setup do 
        UserMailer.stubs(:deliver_activation).returns(true).then.raises(StandardError)
        get :activate, {:activation_code => @u.activation_code}
      end
      
      should "redirect to the dashboard" do
        assert_redirected_to root_path
      end
      
      should "set flash[:notice]" do
        assert_not_nil flash[:notice]
      end
            
      should "activate the user" do
        assert @u.reload.active?
      end
      
      should "verify the user's primary email address" do
        assert Email.find_by_address(@u.reload.primary_email).verified?
      end
      
      should "trigger an account activation email to the user" do
        assert_raises(StandardError) { UserMailer.deliver_activation("blah") }
      end
      
      should "log the user in" do
        assert_not_nil session[:user_id]
      end
      
    end
  end
  
  context "An unregistered account has already been created for quire@example.com" do
    setup do
      @user = User.create!(:email => 'quire@example.com')
    end
    
    context "and user submits the registration form for quire@example.com" do
      setup do
        create_user
      end
    
      should "redirect the user" do
        assert_response :redirect
      end
    
      should "make the existing user pending" do
        assert @user.reload.pending?
      end
    
      should_change 'User.count', :by => 0
      should_change 'User.with_user_state(:unregistered).count', :by => -1
      should_change 'User.with_user_state(:pending).count', :by => 1
    end
    
  end
  
  context "A pending user already shares the same email address" do
    setup do
      u = User.new(user_attrs)
      u.user_state = 'pending'
      u.save!
      create_user
    end
    
    should "respond with a 200 telling the user to select a different email address" do
      assert_response :success
      assert_template 'new'
      assert assigns(:user).errors.on(:email)
    end    
  end
  
  context "An active user already shares the same email address" do
    setup do
      User.create_and_activate(user_attrs)
      create_user
    end
    
    should "respond with a 200 telling the user to select a different email address" do
      assert_response :success
      assert_template 'new'
      assert assigns(:user).errors.on(:email)
    end
  end
  
  context "An active user enters 'ad' into the autocomplete" do
    setup do
      log_in(nick)
      xhr(:post, :find, {:email => 'ad', :format => "js"})
    end
    
    should_respond_with :success
    should "render json" do
      assert_equal "application/json", @response.content_type      
    end
    
    should "return adam@slsdev.net" do
      assert assigns(:users).include?("adam@slsdev.net")
      json = JSON.parse(@response.body)
      assert_equal 1, json['emails'].size
      assert_equal "adam@slsdev.net", json['emails'].first
    end
  end

  protected
    def create_user(options = {})
      post :create, :user => user_attrs.merge(options)
    end
    
    def user_attrs
      { :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69', :name => 'Quire' }
    end
end
