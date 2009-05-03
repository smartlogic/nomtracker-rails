require File.dirname(__FILE__) + '/../test_helper'

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
    setup do
      
    end
    
    should_require :email
    should_require :password
    should_require :password_confirmation
    should_require :name
    
    context "the user submits a valid form" do
      setup do
        #UserMailer.any_instance.stubs(:deliver_signup_notification).returns
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
      
      should "trigger a signup confirmation email to the user which includes the URL to follow to activate the account"
      
    end
  end

  # context "A pending account with the given email address does not already exist" do
    
    def test_should_activate_user
      john = User.new(:name => 'John', :email => 'john@slsdev.net', :password => 'johnjohn', :password_confirmation => 'johnjohn')
      john.user_state = 'pending'
      john.save!
      
      assert_not_nil john.reload.activation_code
      assert_nil User.authenticate('aaron', 'test')
      
      get :activate, :activation_code => john.activation_code
      assert_redirected_to login_url
      assert_not_nil flash[:notice]
      assert_equal john, User.authenticate('john@slsdev.net', 'johnjohn')
    end

    def test_should_not_activate_user_without_key
      get :activate
      assert_nil flash[:notice]
    rescue ActionController::RoutingError
      # in the event your routes deny this, we'll just bow out gracefully.
    end

    def test_should_not_activate_user_with_blank_key
      get :activate, :activation_code => ''
      assert_nil flash[:notice]
    rescue ActionController::RoutingError
      # well played, sir
    end
    
  # end
  
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

  protected
    def create_user(options = {})
      post :create, :user => user_attrs.merge(options)
    end
    
    def user_attrs
      { :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69', :name => 'Quire' }
    end
end
