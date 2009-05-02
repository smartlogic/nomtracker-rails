class Transaction < ActiveRecord::Base
  belongs_to :creditor, :class_name => 'User'
  belongs_to :debtor,   :class_name => 'User'

  validates_presence_of :amount
  validates_presence_of :creditor
  validates_presence_of :debtor

end
