require File.dirname(__FILE__) + '/../test_helper'
require 'json'

def should_create_a_transaction
  should "create a transaction" do
    assert_equal @txn_count + 1, Transaction.count
  end
end

def should_not_create_a_transaction
  should "not create a transaction" do
    assert_equal @txn_count, Transaction.count
  end
end

def should_create_a_user(email)
  should "create a user with email address #{email} and a single transaction" do
    assert_equal @user_count + 1, User.count
    new_user = User.find_by_email(email)
    assert_not_nil new_user
    assert new_user.unregistered?
    assert_equal 1, new_user.transactions.size
  end
end

def should_not_create_a_user
  should "not create a user" do
    assert_equal @user_count, User.count
  end  
end

class TransactionsControllerTest < ActionController::TestCase
  context "an authenticated user" do
    setup do
      log_in adam
      @user_count = User.count
      @txn_count  = Transaction.count
    end

    context "creates a valid credit between existing users" do
      setup do
        post :create, valid_credit_attrs
      end
      
      should_create_a_transaction
      should_not_create_a_user
      
      should "render JSON as a 200" do
        assert_response :success
        assert_equal "application/json", @response.content_type
      end

      should "include updated updated html for credit transactions" do
        json = JSON.parse(@response.body)
        assert_not_nil json['update']['credits']
        assert_not_nil json['messages']['success']
      end
    end
    
    context "creates a valid debt between existing users" do
      setup do
        post :create, valid_debt_attrs
      end
      
      should_create_a_transaction
      should_not_create_a_user
      
      should "render JSON as a 200" do
        assert_response :success
        assert_equal "application/json", @response.content_type
      end

      should "include updated updated html for debt transactions" do
        json = JSON.parse(@response.body)
        assert_not_nil json['update']['debts']
        assert_not_nil json['messages']['success']
      end    
    end
    
    context "creates a valid credit to a nonexistent user" do
      setup do
        post :create, valid_debt_attrs(:email => "someone@slsdev.net")
      end
      
      should_create_a_transaction
      should_create_a_user("someone@slsdev.net")
    end
    
    context "creates a valid debt to a nonexistent user" do
      setup do
        post :create, valid_credit_attrs(:email => "someone@slsdev.net")
      end
      
      should_create_a_transaction
      should_create_a_user("someone@slsdev.net")    
    end
    
    context "creates an invalid credit" do
      setup do
        post :create, valid_credit_attrs(:email => adam.email)
      end
      
      should_not_create_a_transaction
      should_not_create_a_user
    
      should "render JSON as a 422" do
        assert_response 422
        assert_equal "application/json", @response.content_type
      end
    
      should "include error message" do
        json = JSON.parse(@response.body)
        assert_not_nil json['messages']['error']
      end
    end
  end

  context "an unauthenticated user" do
    should "be redirected to login" do
      post :create
      assert_redirected_to login_path
    end
  end
  
  private
    def valid_credit_attrs(options={})
      {:transaction_type => 'credit', :email => nick.email,
        :transaction => {
          :amount => 1,
          :when => 'yesterday',
          :description => 'Bought Nick a bike'
        }
      }.merge(options)
    end
    
    def valid_debt_attrs(options={})
      {:transaction_type => 'debt', :email => nick.email,
        :transaction => {
          :amount => 1,
          :when => 'yesterday',
          :description => 'Borrowed a buck for a popsicle'
        }
      }.merge(options)      
    end
end
