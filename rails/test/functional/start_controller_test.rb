require File.dirname(__FILE__) + '/../test_helper'

class StartControllerTest < ActionController::TestCase
  
  context "An unauthenticated user accesses the root of the site" do
    setup do
      log_out
      get(:index)
    end
    
    should "redirect to the login page" do
      assert_redirected_to login_path
    end
  end
  
  context "An authenticated user accesses the root of the site" do
    setup do
      log_in nick
      get(:index)
    end
    
    should "render the transaction log" do
      assert_response :success
      assert_template 'index'
      # assert assigns(:transactions)
    end
    
    should "display a logout link in the header" do
      assert_select "a", {:href => logout_url}
    end
  end
  
end
