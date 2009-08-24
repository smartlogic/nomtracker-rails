require File.dirname(__FILE__) + '/../test_helper'

class TransactionNotifierTest < ActiveSupport::TestCase
  context '#notify' do
    setup do
      @transaction = new_transaction
    end
    
    context 'when the user to be notified is a party to the transaction' do
      should 'trigger an email' do
        UserMailer.expects(:deliver_transaction_created).with(adam, @transaction)
        TransactionNotifier.notify(@transaction, adam)
      end
    end
    
    context 'when the user to be notified is not a party to the transaction' do
      should 'raise a NotAPartyToTransactionException' do
        assert(michael != @transaction.creditor && michael != @transaction.debtor, 'test is invalid')
        TransactionNotifier.expects(:notify).never
        assert_raises(NotAPartyToTransactionException) { TransactionNotifier.notify_if_necessary(@transaction, michael) }        
      end
    end
    
  end
  
  context '#notify_if_necessary' do
    setup do
      @transaction = new_transaction
    end
    
    context 'when the initiating user is the creditor and the debtor wants to be notified' do
      should 'send notify the debtor' do
        TransactionNotifier.expects(:notify).with(@transaction, @transaction.debtor)
        TransactionNotifier.notify_if_necessary(@transaction, @transaction.creditor)
      end
    end
    
    context 'when the initiating user is the debtor and the creditor wants to be notified' do
      should 'notify the creditor' do
        TransactionNotifier.expects(:notify).with(@transaction, @transaction.creditor)
        TransactionNotifier.notify_if_necessary(@transaction, @transaction.debtor)
      end
    end
    
    context 'when the initiating user is not a party to the transaction' do
      should 'not notify anyone' do
        assert(michael != @transaction.creditor && michael != @transaction.debtor, 'test is invalid')
        TransactionNotifier.expects(:notify).never
        assert_raises(NotAPartyToTransactionException) { TransactionNotifier.notify_if_necessary(@transaction, michael) }
      end
    end
    
    context 'when the user to notify does not want to be notified' do
      setup do
        adam.update_attributes!(:wants_to_be_notified => false)
      end
      
      should 'not notify anyone' do
        assert !adam.wants_to_be_notified?, "test is invalid"
        TransactionNotifier.expects(:notify).never
        TransactionNotifier.notify_if_necessary(@transaction, nick)
      end
    end
    
    context 'when the user to notify is pending' do
      setup do
        @transaction.creditor_email = 'john@slsdev.net'
        @john = @transaction.creditor
      end
      
      should 'not notify anyone' do
        TransactionNotifier.expects(:notify).never
        TransactionNotifier.notify_if_necessary(@transaction, adam)
      end
    end
  end
  
  private
    def new_transaction
      Transaction.new(:creditor => nick, :debtor => adam, :amount => 5)
    end
end