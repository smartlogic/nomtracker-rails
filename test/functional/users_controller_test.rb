require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  # context "A pending account with the given email address does not already exist" do
    def test_should_allow_signup
      assert_difference 'User.count' do
        create_user
        assert_redirected_to root_path
        assert_not_nil flash[:notice]
        assert User.find_by_email('quire@example.com').pending?
      end
    end

    [:name, :password, :password_confirmation, :email].each do |attr|
      src = <<-RUBY
        def test_should_require_#{attr}_on_signup
          create_user(:#{attr} => nil)
          assert assigns(:user).errors.on(:#{attr})
          assert_response :success
          assert_template 'new'
        end
      RUBY
      class_eval src, __FILE__, __LINE__
    end
    
    def test_should_sign_up_user_with_activation_code
      create_user
      assigns(:user).reload
      assert_not_nil assigns(:user).activation_code
    end
    
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
