require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

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
  

  protected
    def create_user(options = {})
      post :create, :user => { :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69', :name => 'Quire' }.merge(options)
    end
end
