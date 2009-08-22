
class NotAPartyToTransactionException < StandardError; end

class TransactionNotifier
  
  # @param transaction [Transaction] the transaction responsible for the notification
  # @param user_to_notify [User] the user to be notified
  # @raise NotAPartyToTransactionException
  def self.notify(transaction, user_to_notify)
    raise NotAPartyToTransactionException if ![transaction.creditor, transaction.debtor].include?(user_to_notify)
    UserMailer.deliver_transaction_created(user_to_notify, transaction)
  end
  
  # @param transaction [Transaction] the transaction responsible for notification
  # @param initiating_user [User] the user that initiated the transaction
  # @raise NotAPartyToTransactionException
  def self.notify_if_necessary(transaction, initiating_user)
    raise NotAPartyToTransactionException if ![transaction.creditor, transaction.debtor].include?(initiating_user)
    user_to_notify = (transaction.creditor == initiating_user) ? transaction.debtor : transaction.creditor
    if user_to_notify.wants_to_be_notified?
      notify(transaction, user_to_notify)
    end
  end
  
end