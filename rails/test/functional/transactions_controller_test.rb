require File.dirname(__FILE__) + '/../test_helper'
require 'json'

class TransactionsControllerTest < ActionController::TestCase
  context "an authenticated user" do
    setup do
      log_in adam
    end

    should "create transaction" do
      assert_difference('Transaction.count') do
        post :create, valid_single_transaction_attrs
        assert_response :success
      end
    end

    should "not be able to create a transaction from and to yourself" do
      assert_difference('Transaction.count', 0) do
        post :create, valid_single_transaction_attrs(:email => adam.email)
        assert_response :success
      end
    end

    should "update transaction" do
      put :update, :id => Transaction.first.id, :transaction => { }
      assert_response :ok
    end

    should "destroy transaction" do
      assert_difference('Transaction.count', -1) do
        delete :destroy, :id => Transaction.first.id
      end
      assert_response :ok
    end
    
    context "creates a valid credit" do
      setup do
        post :create, valid_single_transaction_attrs
      end
      
      should "render JSON as a 200" do
        assert_response :success
        assert_equal "application/json", @response.content_type
      end

      should "include updated updated html for pending transactions" do
        json = JSON.parse(@response.body)
        assert_not_nil json['update']['pending']
        assert_not_nil json['messages']['success']
      end
    end
    
    context "creates an invalid credit" do
      setup do
        post :create, valid_single_transaction_attrs(:email => adam.email)
      end
    
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
    def valid_single_transaction_attrs(options={})
      {:transaction_type => 'credit', :email => nick.email,
        :transaction => {
          :amount => 1,
          :when => 'yesterday',
          :description => 'Bought Nick a bike'
        }
      }.merge(options)
    end
end
