class Transaction < ActiveRecord::Base
  belongs_to :creditor, :class_name => 'User'
  belongs_to :debtor,   :class_name => 'User'

  validates_presence_of :amount
  validates_presence_of :creditor
  validates_presence_of :debtor

  def creditor_email=(email)
    self.creditor = User.find_by_email(email)
  end
  def debtor_email=(email)
    self.debtor = User.find_by_email(email)
  end
  def creditor_email
    return "" if creditor.nil?
    creditor.email
  end
  def debtor_email
    return "" if debtor.nil?
    debtor.email
  end
end
