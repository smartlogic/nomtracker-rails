require File.dirname(__FILE__) + '/../test_helper'

def should_fail_to_add_email_address
  should_respond_with 422
  should_respond_with_content_type 'application/json'
  
  should_change 'Email.count', :by => 0
  should "return error message" do
    json = JSON.parse(@response.body)
    assert_not_nil json['messages']
    assert_not_nil json['messages']['error']
  end
end

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
    
    context "and adds a new email address nick2@slsdev.net that is available" do
      setup do
        ActionMailer::Base.deliveries = []
        xhr(:post, :add_email, {:address => 'nick2@slsdev.net'})
      end
      
      should_respond_with :success
      should_respond_with_content_type 'application/json'

      should_change 'Email.count', :by => 1
      should_change 'nick.emails.count', :by => 1
      should "create a new pending email address" do
        assert nick.emails(true).last.pending?
      end
      
      should "return success message" do
        json = JSON.parse(@response.body)
        assert_not_nil json['messages']
        assert_not_nil json['messages']['success']
      end
      
      should "return updated email addresses" do
        json = JSON.parse(@response.body)
        assert_not_nil json['emails']
        assert json['emails'].any?{|hsh| hsh['address'] == 'nick2@slsdev.net'}
      end
      
      should "send an activation email to nick2@slsdev.net" do
        sent = ActionMailer::Base.deliveries
        assert_equal 1, sent.size
        assert_equal "nick2@slsdev.net", Array(sent.first.to).first
      end
      
    end
    
    context "and adds an invalid email address" do
      setup do
        xhr(:post, :add_email, {:address => 'abcdef'})
      end
      
      should_fail_to_add_email_address
    end
    
    context "and adds an email address that already belongs to another verified user" do
      setup do
        xhr(:post, :add_email, {:address => adam.primary_email.address})
      end
      
      should_fail_to_add_email_address
    end
    
    # in other words, existing users have created transaction for an email address that
    # she hasn't claimed yet.
    context "and adds an email address that belongs to an unregistered user" do
      
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
