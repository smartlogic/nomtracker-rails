class Email < ActiveRecord::Base
  include Authentication
  
  belongs_to :user
  
  validates_presence_of     :user_id, :address
  validates_length_of       :address,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :address
  validates_format_of       :address,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
end
