require 'digest/sha1'
require 'state_machine'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_length_of :user_state, :maximum => 30

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message      

  has_many :credits, 
    :class_name => 'Transaction',
    :foreign_key => 'creditor_id',
    :order => 'created_at DESC'
  has_many :debts,
    :class_name => 'Transaction', 
    :foreign_key => 'debtor_id', 
    :order => 'created_at DESC'
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_by_email(email.downcase) # need to get the salt
    u && u.authenticated?(password) && u.active? ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def self.create_and_activate(attrs={})
    u = User.new(attrs)
    u.user_state = 'active'
    u.save
    u
  end
  
  state_machine :user_state, :initial => :unregistered do
    
    event :register do
      transition :unregistered => :pending
    end
    
    event :activate do
      transition :pending => :active
    end
    
    state :pending do
      before_save :make_activation_code

      validates_presence_of     :password,                   :if => :password_required?
      validates_presence_of     :password_confirmation,      :if => :password_required?
      validates_confirmation_of :password,                   :if => :password_required?
      validates_length_of       :password, :within => 6..40, :if => :password_required?
      
      validates_presence_of     :name
      validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
      validates_length_of       :name,     :maximum => 100
    end
    
    state :active do
      validates_presence_of     :password,                   :if => :password_required?
      validates_presence_of     :password_confirmation,      :if => :password_required?
      validates_confirmation_of :password,                   :if => :password_required?
      validates_length_of       :password, :within => 6..40, :if => :password_required?
      
      validates_presence_of     :name
      validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
      validates_length_of       :name,     :maximum => 100
    end
  end
  
  
  def transactions
    Transaction.find(
      :all,
      :conditions => ['creditor_id = ? OR debtor_id = ?', id, id],
      :order => 'created_at DESC'
    )
  end
  
  def pending_transactions
    []
  end
  
  def nomworth
    credits.sum(:amount) - debts.sum(:amount)
    # transactions.inject(0) {|total, t| 
    #   if t.creditor_id == id
    #     total + t.amount
    #   else
    #     total - t.amount
    #   end
    # }
  end
  
  private
    def make_activation_code
      self.activation_code = self.class.make_token
    end
      
end
