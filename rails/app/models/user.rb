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
    :foreign_key => 'creditor_id'
  has_many :debts,
    :class_name => 'Transaction', 
    :foreign_key => 'debtor_id'
  
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
  
  # Those users that you have past transactions with
  def network
    arr = 
      self.credits.find(:all, :select => "DISTINCT users.email", :joins => "INNER JOIN users ON users.id = transactions.debtor_id", :conditions => ["users.id != ?", id]).map(&:email) + 
      self.debts.find(:all, :select => "DISTINCT users.email", :joins => "INNER JOIN users ON users.id = transactions.creditor_id", :conditions => ["users.id != ?", id]).map(&:email)
    arr.uniq
  end
  
  def network_as_users
    arr =
      self.credits.find(:all, :include => :debtor).map(&:debtor) +
      self.debts.find(:all, :include => :creditor).map(&:creditor)
    arr.uniq
  end
  
  def balance_with(user)
    self.credits.to_user(user).sum(:amount) - self.debts.from_user(user).sum(:amount)
  end
  
  # returns array of Balance objects for each non-zero balance this user has
  def balances
    # Very inefficient at this point for a large network...
    self.network_as_users.map { |user| 
      {:balance => self.balance_with(user), :user => user}
    }.select {|balance| balance[:balance].to_f != 0.0}
  end
  
  def nomworth
    credits.sum(:amount) - debts.sum(:amount)
  end
  
  private
    def make_activation_code
      self.activation_code = self.class.make_token
    end
      
end
