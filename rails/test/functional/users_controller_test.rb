require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  # context "A pending account with the given email address does not already exist" do
    def test_should_allow_signup
      assert_difference 'User.count' do
        create_user
        assert_response :redirect
        assert_equal 'active', User.find_by_email('quire@example.com').user_state
      end
    end

    def test_should_require_name_on_signup
      assert_no_difference 'User.count' do
        create_user(:name => nil)
        assert assigns(:user).errors.on(:name)
        assert_response :success
      end
    end

    def test_should_require_password_on_signup
      assert_no_difference 'User.count' do
        create_user(:password => nil)
        assert assigns(:user).errors.on(:password)
        assert_response :success
      end
    end

    def test_should_require_password_confirmation_on_signup
      assert_no_difference 'User.count' do
        create_user(:password_confirmation => nil)
        assert assigns(:user).errors.on(:password_confirmation)
        assert_response :success
      end
    end

    def test_should_require_email_on_signup
      assert_no_difference 'User.count' do
        create_user(:email => nil)
        assert assigns(:user).errors.on(:email)
        assert_response :success
      end
    end
  # end
  
  context "A pending account with the given email address does exist and a user submits the registration form" do
    setup do
      @user = User.create!(:email => 'quire@example.com')
      @original_user_count = User.count
      @original_pending_user_count = User.with_user_state(:pending).count
      @original_active_user_count = User.with_user_state(:active).count
      create_user
    end
    
    should "redirect the user" do
      assert_response :redirect
    end
    
    should "not create a new User when creating the account" do
      assert_equal @original_user_count, User.count
    end
    
    should "activate the existing user" do
      assert_equal 'active', @user.reload.user_state
    end
    
    should "decrease pending users by 1" do
      assert_equal @original_pending_user_count - 1, User.with_user_state(:pending).count
    end
    
    should "increase active users by 1" do
      assert_equal @original_active_user_count + 1, User.with_user_state(:active).count      
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
