require 'state_machine'

class Email < ActiveRecord::Base
  include Authentication
  
  belongs_to :user
  
  validates_presence_of     :user_id, :address
  validates_length_of       :address,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :address
  validates_format_of       :address,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  state_machine :email_state, :initial => :pending do
    
    event :activate do
      transition :pending => :active
    end
    
    state :pending do
      before_save :make_activation_code
      def make_activation_code
        self.activation_code = self.class.make_token
      end
      private :make_activation_code
    end
    
    state :active do
      
    end
  end  
  
end
