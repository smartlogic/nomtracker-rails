require File.dirname(__FILE__) + '/../test_helper'

def should_respond_to(att)
  should "respond to #{att}" do
    assert @transaction.respond_to?(att)
  end
end

def should_require(att)
  should "require #{att}" do
    @transaction.send("#{att}=", nil)
    assert !@transaction.valid?
    assert @transaction.errors.on(att)
  end
end

class TransactionTest < ActiveSupport::TestCase
  context "A transaction object" do
    setup do 
      @transaction = Transaction.new(:amount => 10.50, :debtor => adam, :creditor => nick, :when => "Friday at 10PM", :description => "Beers at the Depot")
    end
    
    should_require :amount
    should_require :debtor_id
    should_require :creditor_id
    should_respond_to :when
    should_respond_to :description
    
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
    
end
