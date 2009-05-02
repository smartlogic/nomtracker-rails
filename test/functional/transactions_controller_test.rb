require File.dirname(__FILE__) + '/../test_helper'

class TransactionsControllerTest < ActionController::TestCase
  context "an authenticated user" do
    setup do
      log_in adam
    end

    should "create transaction" do
      assert_difference('Transaction.count') do
        post :create, :transaction => {
          :creditor => adam,
          :debtor => nick,
          :amount => 1
        }
        assert_response :success
      end
    end

    should "create transaction from emails" do
      assert_difference('Transaction.count') do
        post :create, :transaction => {
          :creditor_email => adam.email,
          :debtor_email => nick.email,
          :amount => 1
        }
        assert_response :success
      end
    end

    should "not be able to create a transaction for someone else" do
      assert_difference('Transaction.count', 0) do
        post :create, :transaction => {
          :creditor_email => nick.email,
          :debtor_email => michael.email,
          :amount => 1
        }
      end
    end

    should "not be able to create a transaction from and to yourself" do
      assert_difference('Transaction.count', 0) do
        post :create, :transaction => {
          :creditor_email => adam.email,
          :debtor_email => adam.email,
          :amount => 1
        }
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
  end


  context "an unauthenticated user" do
    should "be redirected to login" do
      post :create
      assert_redirected_to login_path
    end
  end
end
