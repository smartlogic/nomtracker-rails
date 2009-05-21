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
      
      should "redirect to the login page" do
        assert_redirected_to login_url
      end
      
      should "set flash[:notice]" do
        assert_not_nil flash[:notice]
      end
            
      should "activate the user" do
        assert @u.reload.active?
      end
      
      should "trigger an account activation email to the user" do
        assert_raises(StandardError) { UserMailer.deliver_activation("blah") }
      end
      
    end
  end
  
  context "An unregistered account with the given email address does exist and a user submits the registration form" do
    setup do
      @user = User.create!(:email => 'quire@example.com')
      @original_user_count = User.count
      @original_unregistered_user_count = User.with_user_state(:unregistered).count
      @original_pending_user_count = User.with_user_state(:pending).count
      create_user
    end
    
    should "redirect the user" do
      assert_response :redirect
    end
    
    should "not create a new User when creating the account" do
      assert_equal @original_user_count, User.count
    end
    
    should "make the existing user pending" do
      assert @user.reload.pending?
    end
    
    should "decrease unregistered users by 1" do
      assert_equal @original_unregistered_user_count - 1, User.with_user_state(:unregistered).count
    end
    
    should "increase pending users by 1" do
      assert_equal @original_pending_user_count + 1, User.with_user_state(:pending).count
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
    # should "render json" do
    #   assert_equal "application/json", @response.content_type      
    # end
    
    should "return adam@slsdev.net" do
      assert assigns(:email).include?("adam@slsdev.net")
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
