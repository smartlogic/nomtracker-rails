require File.dirname(__FILE__) + '/../test_helper'

class TransactionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transactions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction" do
    assert_difference('Transaction.count') do
      post :create, :transaction => {
        :creditor => adam,
        :debtor => nick,
        :amount => 1
      }
      assert_equal 'Transaction was successfully created.', flash[:notice]
    end

    assert_redirected_to transaction_path(assigns(:transaction))
  end

  test "should show transaction" do
    get :show, :id => Transaction.first.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Transaction.first.id
    assert_response :success
  end

  test "should update transaction" do
    put :update, :id => Transaction.first.id, :transaction => { }
    assert_redirected_to transaction_path(assigns(:transaction))
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete :destroy, :id => Transaction.first.id
    end

    assert_redirected_to transactions_path
  end
end
