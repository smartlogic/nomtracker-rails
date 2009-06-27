require 'digest/sha1'
require 'state_machine'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_length_of :user_state, :maximum => 30

  has_many :emails
  has_many :credits,      :class_name => 'Transaction', :foreign_key => 'creditor_id'
  has_many :debts,        :class_name => 'Transaction', :foreign_key => 'debtor_id'
  has_many :transactions, :class_name => 'NormalizedTransaction', :foreign_key => 'me'
    
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation
    
  state_machine :user_state, :initial => :unregistered do
    
    event :register do
      transition :unregistered => :pending
    end
    
    event :activate do
      transition :pending => :active
    end
    
    state :pending do
      before_save :make_activation_code
      def make_activation_code
        self.activation_code = self.class.make_token
      end
      private :make_activation_code

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

  ######### EMAIL SHORTCUTS ##########

  def self.find_by_email(address)
    address = (address ? address.downcase : nil)
    User.find(:first, :include => :emails, :conditions => ['emails.address = ?', address])
  end

  before_save :preprocess_email
  after_save :process_email

  # shortcut for creating an associated email address
  def email=(value)
    @email_to_save = value
    #self.emails << Email.new(:address => (value ? value.downcase : nil))
  end
  
  def primary_email
    self.emails.first.address
  end
  
  def preprocess_email
    proceed = @email_to_save.nil? || !Email.exists?(:address => @email_to_save)
    errors.add(:email, "Email address is already taken") if !proceed
    proceed
  end
  
  def process_email
    return if @email_to_save.nil?
    Email.create(:user => self, :address => @email_to_save)
    @email_to_save = nil
  end
  private :preprocess_email, :process_email

  ######### EMAIL SHORTCUTS ##########
  
  def self.create_and_activate(attrs={})
    u = User.new(attrs)
    u.user_state = 'active'
    u.save
    u
  end
    
  def pending_transactions
    []
  end
  
  # Those users that you have past transactions with
  def network
    arr = 
      self.credits.find(:all, :select => "DISTINCT emails.address", :joins => "INNER JOIN users ON users.id = transactions.debtor_id INNER JOIN emails ON emails.user_id = users.id", :conditions => ["users.id != ?", id]).map(&:address) + 
      self.debts.find(:all, :select => "DISTINCT emails.address", :joins => "INNER JOIN users ON users.id = transactions.creditor_id INNER JOIN emails ON emails.user_id = users.id", :conditions => ["users.id != ?", id]).map(&:address)
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
  
end
