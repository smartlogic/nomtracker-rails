require File.dirname(__FILE__) + '/../test_helper'

class TransactionTest < ActiveSupport::TestCase
  
  should_validate_presence_of :amount, :debtor_id, :creditor_id
  should_ensure_length_in_range :when, 0..50
  should_ensure_length_in_range :description, 0..255
  
  context "A transaction object" do
    setup do 
      @transaction = Transaction.new(:amount => 10.50, :debtor => adam, :creditor => nick, :when => "Friday at 10PM", :description => "Beers at the Depot")
    end
        
    should "not allow debtor and creditor to be the same" do
      @transaction.debtor = @transaction.creditor
      assert !@transaction.valid?
    end
  end

  should "set creditor and debtor from email" do
    t = Transaction.new(
      :creditor_email => adam.email,
      :debtor_email => nick.email
    )
    assert_equal adam, t.creditor
    assert_equal nick, t.debtor
    assert_equal adam.email, t.creditor_email
    assert_equal nick.email, t.debtor_email
  end
  
  context "When assigning a nonexistent user to debtor_email" do
    setup do
      @user_count = User.count
      @transaction = Transaction.new(:creditor => adam, :debtor_email => "someone@slsdev.net")
    end
    
    should "create a new user" do
      assert_equal @user_count + 1, User.count
    end
    
    should "assign the newly created user as the debtor" do
      assert_equal User.find_by_email('someone@slsdev.net'), @transaction.debtor
    end
  end
    
end
