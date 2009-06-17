class Email < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id, :address
  validates_length_of :address, :maximum => 100
end
