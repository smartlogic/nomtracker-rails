require File.dirname(__FILE__) + '/../test_helper'

def should_render_index
  should_respond_with :success
  should_render_template :index
  should_render_logout_link
  should "include link to view all transactions" do
    assert_select("a", {:href => transactions_path})
  end
end

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
  
  context "An authenticated user accesses their dashboard" do
    setup do
      log_in nick
      get :index
    end
    
    should_render_index
  end
  
  context "When a user with nonzero balances views their dashboard" do
    setup do
      log_in nick
      get :index
    end
    
    should_render_index
    should_render("#tbl_balances")
    should_not_render("#no_balances")
  end
  
  context "When a user with no nonzero balances views their dashboard" do
    setup do
      @john = create_john
      log_in @john
      get :index
    end
    
    should_render_index
    should_not_render("#tbl_balances")
    should_render("#no_balances")
  end
  
  context "When a user nick with 5 debts and 4 credits views his dasboard" do
    setup do
      log_in nick
      get :index
    end
    
    should_render('#tbl_recent_transactions')
    should_not_render('#no_recent_transactions')
    
    should 'display 6 rows in #tbl_recent_transactions' do
      assert_select '#tbl_recent_transactions tr', {:count => 6} # 1 extra for header
    end
  end
  
  context "When a user john with 0 debts and 0 credits views his dashboard" do
    setup do
      @john = create_john
      log_in @john
      get :index
    end
    
    should_render('#no_recent_transactions')
    should_not_render('#tbl_recent_transactions')
  end
  
end
