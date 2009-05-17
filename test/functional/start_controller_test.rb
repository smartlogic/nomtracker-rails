require File.dirname(__FILE__) + '/../test_helper'

def should_render_logout_link
  should "display a logout link in the header" do
    assert_select "a", {:href => logout_url}
  end
end

def should_render_root_properly
  should_respond_with :success
  should_render_template :index
  should_render_logout_link
end

def should_render(css_selector)
  should "render #{css_selector}" do
    assert_select css_selector
  end
end

def should_not_render(css_selector)
  should "not render #{css_selector}" do
    assert_select css_selector, false
  end
end

# Used such that the named_scope chain will return a count of 0 to allow us to test "empty" messages
def mock_empty_named_scope(model, named_scope)
  # For any instance of model, stub the named_scope and have it return an object that responds to :count with a value of 0
  model.any_instance.stubs(named_scope).returns(mock(:count => 0))
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
  
  context "An authenticated user" do
    setup do
      log_in nick
    end
    
    context "who has no pending transactions accesses the root of the site" do
      setup do
        # This will probably change when we actually implement pending txns
        User.any_instance.stubs(:pending_transactions).returns([])
        get(:index)
      end
      
      should_render_root_properly
      should_render "#no_pending_transactions"
      should_not_render "#tbl_pending_transactions"
    end
    
    context "who has pending transactions accesses the root of the site" do
      setup do
        # This will probably change when we actually implement pending txns
        User.any_instance.stubs(:pending_transactions).returns(["faking this...will need to fix when we actually implement this feature"])
        get(:index)
      end
      
      should_render_root_properly
      should_not_render "#no_pending_transactions"
      should_render "#tbl_pending_transactions"
    end
    
    context "who has no credits accesses the root of the site" do
      setup do
        mock_empty_named_scope(User, :credits)
        get(:index)
      end
    
      should_render_root_properly
      should_not_render "#tbl_credits"
      should_render "#no_credits"
    end
    
    context "who has credits accesses the root of the site" do
      setup do
        get(:index)
      end
      
      should_render_root_properly
      should_render "#tbl_credits"
      should_not_render "#no_credits"
    end
    
    context "who has no debits accesses the root of the site" do
      setup do
        mock_empty_named_scope(User, :debts)
        get(:index)
      end
    
      should_render_root_properly    
      should_not_render "#tbl_debts"
      should_render "#no_debts"    
    end
    
    context "who has debits accesses the root of the site" do
      setup do
        get(:index)
      end
    
      should_render_root_properly    
      should_render "#tbl_debts"
      should_not_render "#no_debts"
    end
    
  end
  
  
end
