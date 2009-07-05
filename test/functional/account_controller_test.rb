require File.dirname(__FILE__) + '/../test_helper'

def should_return_error_message
  should "return an error message" do
    json = JSON.parse(@response.body)
    assert_not_nil json['messages']
    assert_not_nil json['messages']['error']
  end  
end

def should_fail_to_add_email_address
  should_respond_with 422
  should_respond_with_content_type 'application/json'
  
  should_change 'Email.count', :by => 0
  should_return_error_message
end

def should_send_activation_email
  should "send an activation email to nick2@slsdev.net" do
    sent = ActionMailer::Base.deliveries
    assert_equal 1, sent.size
    assert_equal "nick2@slsdev.net", Array(sent.first.to).first
  end
end

def should_not_send_activation_email
  should_respond_with 422
  should_respond_with_content_type 'application/json'

  should "not send an activation email" do
    sent = ActionMailer::Base.deliveries
    assert_equal 0, sent.size
  end
  
  should_return_error_message
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
      
      should_send_activation_email
      
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
    
    context "and the user with email address john@slsdev.net is currently unregistered because a transaction has been created with it" do
      setup do
        # john does not exist yet
        @transaction = Transaction.create!(:amount => 5.00, :creditor_email => 'nick2@slsdev.net', :debtor => adam)
      end
      
      # in other words, existing users have created transaction for an email address that
      # she hasn't claimed yet.
      context "and nick adds the email address nick2@slsdev.net to his account" do
        
        setup do
          ActionMailer::Base.deliveries = []
          xhr(:post, :add_email, {:address => 'nick2@slsdev.net'})
        end

        should_respond_with :success
        should_respond_with_content_type 'application/json'
        
        should_change 'User.count', :by => -1
        should_change 'Email.count', :by => 0
        should_change 'nick.emails.count', :by => 1
        should_change 'Transaction.count', :by => 0
        
        should "delete the user created to support the transaction in the first place" do
          assert_raise(ActiveRecord::RecordNotFound) { User.find(@transaction.creditor.id) }
        end
        
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

        should_send_activation_email
        
      end
    end
    
    context "and has an unverified email address nick2@slsdev.net" do
      setup do
        ActionMailer::Base.deliveries = []
        @new_email = nick.emails.create!(:address => 'nick2@slsdev.net')
      end
      
      context 'and requests to re-send his activation email' do
        setup do
          xhr(:get, :resend_activation, :email_id => @new_email.id)
        end
        
        should_respond_with :success
        should_respond_with_content_type 'application/json'
        
        should_send_activation_email
      end
      
      context 'and requests to re-send an activation email for a verified email' do
        setup do
          xhr(:get, :resend_activation, :email_id => nick.primary_email.id)
        end
        
        should_not_send_activation_email
      end
      
      context 'and requests to re-send an activation email for an email that belongs to someone else' do
        setup do
          adams_new_email = adam.emails.create!(:address => 'adam2@slsdev.net')
          xhr(:get, :resend_activation, :email_id => adams_new_email.id)
        end
        
        should_not_send_activation_email
      end
      
      context 'and requests to re-send an activation email for a nonexistent email address' do
        setup do
          xhr(:get, :resend_activation, :email_id => -1)
        end
        
        should_not_send_activation_email        
      end
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
