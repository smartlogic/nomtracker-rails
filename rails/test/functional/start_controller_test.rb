require File.dirname(__FILE__) + '/../test_helper'

def should_render_index
  should_respond_with :success
  should_render_template :index
  should_render_logout_link
  should "include link to view all transactions" do
    assert_select("a", {:href => transactions_path})
  end
end

def should_not_send_please_join_email
  should_respond_with 422
  should_respond_with_content_type 'application/json'
  
  should_flash :error
  should "not send an email to adam" do
    assert_equal 0, ActionMailer::Base.deliveries.size
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
  
  context "When nick is logged in" do
    setup do
      log_in nick
    end
    
    context "and has a credit with the unverified address john@slsdev.net" do
      setup do
        @trans = Transaction.create!(:creditor => nick, :debtor_email => 'john@slsdev.net', :amount => 10)
        @john = User.find_by_email('john@slsdev.net')
        ActionMailer::Base.deliveries = []
      end
      
      context 'and invites john@slsdev.net to join nomtracker' do
        setup do
          xhr(:post, :send_invite, {:email_id => @john.primary_email.id})
        end
        
        should_respond_with :success
        should_respond_with_content_type 'application/json'
        
        should_flash :success
        should "send an email to john@slsdev.net" do
          assert_equal 1, ActionMailer::Base.deliveries.size
          assert_equal 'john@slsdev.net', Array(ActionMailer::Base.deliveries[0].to).first
        end
      end
      
      context 'and invites an already verified email [adam@slsdev.net] to join nomtracker' do
        setup do
          xhr(:post, :send_invite, {:email_id => adam.primary_email.id})          
        end
        
        should_not_send_please_join_email
      end
      
      context 'and invites a nonexistent email address to join nomtracker' do
        setup do
          xhr(:post, :send_invite, {:email_id => -1})
        end
        
        should_not_send_please_join_email
      end
    end
  end
  
end
