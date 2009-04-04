class Transaction < ActiveRecord::Base
  belongs_to :from_user, :class_name => 'User'
  belongs_to :to_user, :class_name => 'User'

  validates_presence_of :amount
  validates_presence_of :from_user
  validates_presence_of :to_user

end
