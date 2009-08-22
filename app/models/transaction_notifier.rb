class TransactionNotifier
  
  def self.notify(transaction, user_to_notify)
    UserMailer.deliver_transaction_created(user_to_notify, transaction)    
  end
  
  def self.notify_if_necessary(transaction, initiating_user)
    user_to_notify = (transaction.creditor == initiating_user) ? transaction.debtor : transaction.creditor
    if user_to_notify.wants_to_be_notified?
      notify(transaction, initiating_user)
    end
  end
  
end