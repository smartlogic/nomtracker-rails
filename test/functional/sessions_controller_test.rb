require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  def test_should_login_and_redirect
    post :create, :email => adam.primary_email.address, :password => 'adamadam'
    assert session[:user_id]
    assert_response :redirect
  end

  context "When a user submits invalid credentials when loggin in" do
    setup do
      post :create, :email => adam.primary_email.address, :password => 'notadam'
    end
    
    should "not log the person in" do
      assert_nil session[:user_id]
    end
    
    should "re-render the login form" do
      assert_response :success
      assert_template 'new'
    end
    
    should "display an error message" do
      assert assigns(:error)
      assert_select "p.error", {:text => assigns(:error)}
    end
  end

  def test_should_logout
    log_in adam
    get :destroy
    assert_nil session[:user_id]
    assert_response :redirect
  end

  def test_should_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :email => adam.primary_email.address, :password => 'adamadam', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :email => adam.primary_email.address, :password => 'adamadam', :remember_me => "0"
    assert @response.cookies["auth_token"].blank?
  end
  
  def test_should_delete_token_on_logout
    log_in adam
    get :destroy
    assert @response.cookies["auth_token"].blank?
  end

  def test_should_login_with_cookie
    adam.remember_me
    @request.cookies["auth_token"] = cookie_for(adam)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    adam.remember_me
    adam.update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(adam)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    adam.remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token user.remember_token
    end
end
