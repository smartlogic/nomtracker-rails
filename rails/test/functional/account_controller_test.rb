require File.dirname(__FILE__) + '/../test_helper'

class AccountControllerTest < ActionController::TestCase
  context "When nick is logged in" do
    setup do
      log_in nick
    end
    
    context "and requests the account index" do
      setup do
        get :index
      end
      
      should_respond_with :success
      should_render_template 'index'
    end
  end
  
  context "When a user is not logged in and requests the index" do
    setup do
      log_out
      get :index
    end
    
    should_redirect_to_login
  end
end
