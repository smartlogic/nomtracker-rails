require File.dirname(__FILE__) + '/../test_helper'

def should_render_index
  should_respond_with :success
  should_render_template :index
  should_render_logout_link
end

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

def should_update_nomworth
  should "include updated nomworth" do
    json = JSON.parse(@response.body)
    assert_not_nil json['update']['nomworth']
  end
end

def should_not_update_nomworth
  should "not include updated nomworth" do
    json = JSON.parse(@response.body)
    assert json['update'].nil? || json['update']['nomworth'].nil?
  end
end

def should_update_balances
  should "return updated balances table" do
    json = JSON.parse(@response.body)
    assert_not_nil json['update']['balances']
  end
end

def should_not_update_balances
  should "not return updated balances table" do
    json = JSON.parse(@response.body)
    assert json['update'].nil? || json['update']['balances'].nil?
  end
end

def should_update_transactions
  should "return updated transactions table" do
    json = JSON.parse(@response.body)
    assert_not_nil json['update']['transactions']
  end
end

# Used such that the named_scope chain will return a count of 0 to allow us to test "empty" messages in views
def mock_empty_named_scope(model, named_scope)
  # For any instance of model, stub the named_scope and have it return an object that responds to :count with a value of 0
  model.any_instance.stubs(named_scope).returns(mock(:count => 0))
end

class TransactionsControllerTest < ActionController::TestCase
  context "When a user with no credits views their transaction list" do
    setup do
      log_in nick
      mock_empty_named_scope(User, :credits)
      get :index
    end
    
    should_render_index
    should_not_render "#tbl_credits"
    should_render "#no_credits"
    
  end
  
  context "When a user with credits views their transaction list" do
    setup do
      log_in nick
      get :index
    end
    
    should_render_index
    should_render "#tbl_credits"
    should_not_render "#no_credits"
  end
  
  context "When a user with no debts views their transaction list" do
    setup do
      log_in nick
      mock_empty_named_scope(User, :debts)
      get :index
    end
    
    should_render_index
    should_not_render "#tbl_debts"
    should_render "#no_debts"    
  end
  
  context "When a user with debts views their transaction list" do
    setup do
      log_in nick
      get :index
    end
    
    should_render_index
    should_render "#tbl_debts"
    should_not_render "#no_debts"
  end
  
  context "When a user who has no pending transactions views their transaction list" do
    setup do
      log_in nick
      # This will probably change when we actually implement pending txns
      User.any_instance.stubs(:pending_transactions).returns([])
      get(:index)
    end
    
    should_render_index
    should_render "#no_pending_transactions"
    should_not_render "#tbl_pending_transactions"
  end
  
  context "When a user who has pending transactions views their transaction list" do
    setup do
      log_in nick
      # This will probably change when we actually implement pending txns
      User.any_instance.stubs(:pending_transactions).returns(["faking this...will need to fix when we actually implement this feature"])
      get(:index)
    end
    
    should_render_index
    should_not_render "#no_pending_transactions"
    should_render "#tbl_pending_transactions"
  end
  
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
      
      should_update_balances
      should_update_transactions
      should_update_message(:success)
      should_update_nomworth
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

      should_update_balances
      should_update_transactions
      should_update_message(:success)
      should_update_nomworth
    end
    
    context "creates a valid credit to a nonexistent user" do
      setup do
        post :create, valid_debt_attrs(:email => "someone@slsdev.net")
      end
      
      should_create_a_transaction
      should_create_a_user("someone@slsdev.net")
      should_update_nomworth
      should_update_balances
      should_update_transactions
      should_update_message(:success)
    end
    
    context "creates a valid debt to a nonexistent user" do
      setup do
        post :create, valid_credit_attrs(:email => "someone@slsdev.net")
      end
      
      should_create_a_transaction
      should_create_a_user("someone@slsdev.net")
      should_update_nomworth
      should_update_balances
      should_update_transactions
      should_update_message(:success)
    end
    
    context "creates an invalid credit" do
      setup do
        post :create, valid_credit_attrs(:email => adam.primary_email.address)
      end
      
      should_not_create_a_transaction
      should_not_create_a_user
    
      should "render JSON as a 422" do
        assert_response 422
        assert_equal "application/json", @response.content_type
      end
    
      should_not_update_balances
      should_update_message(:error)
      should_not_update_nomworth
    end
  end

  context "When an unauthenticated user tries to post to create" do
    setup do
      log_out
      get :index
    end
    
    should_redirect_to_login
  end
  
  private
    def valid_credit_attrs(options={})
      {:transaction_type => 'credit', :email => nick.primary_email.address,
        :transaction => {
          :amount => 1,
          :when => 'yesterday',
          :description => 'Bought Nick a bike'
        }
      }.merge(options)
    end
    
    def valid_debt_attrs(options={})
      {:transaction_type => 'debt', :email => nick.primary_email.address,
        :transaction => {
          :amount => 1,
          :when => 'yesterday',
          :description => 'Borrowed a buck for a popsicle'
        }
      }.merge(options)      
    end
end
