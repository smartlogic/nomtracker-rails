require File.dirname(__FILE__) + '/../test_helper'

class StartControllerTest < ActionController::TestCase
  
  context "An unauthenticated user accesses the root of the site" do
    setup do
      log_out
      get(:index)
    end
    
    should "render the splash page" do
      assert_response :success
      assert_template 'splash'
    end
    
    should "display a login link" do
      assert_select "a", {:href => new_session_path}
    end
    
  end
  
  context "An authenticated user accesses the root of the site" do
    setup do
      log_in adam
      get(:index)
    end
    
    should "render the transaction log" do
      assert_response :success
      assert_template 'index'
      assert assigns(:transactions)
    end
    
    should "display a logout link in the header" do
      #assert_select "#header #actions"
    end
  end
  
end
