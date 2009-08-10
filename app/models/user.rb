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

    state :unregistered do

    end

    state :pending do
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

      def add_email(address)
        self.emails.create!(:address => address)
      end
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
    return nil if u.nil?
    user_email = u.emails.find(:first, :conditions => {:address => email})
    user_email && user_email.active? && u.authenticated?(password) && u.active? ? u : nil
  end

  ######### EMAIL SHORTCUTS ##########

  def self.find_by_email(address)
    address = (address ? address.downcase : nil)
    User.find(:first, :include => :emails, :conditions => ['emails.address = ?', address])
  end

  def primary_email
    self.emails.first
  end

  before_save :preprocess_email
  after_save :process_email

  # shortcut for creating an associated email address
  def email=(value)
    raise 'Cannot directly assign an email when an email has already been added' if self.emails.size > 0
    @email_to_save = value
  end

  def preprocess_email
    if @email_to_save.nil? && self.emails.size == 0
      errors.add(:email, "is required")
    elsif !@email_to_save.nil? && Email.exists?(:address => @email_to_save)
      errors.add(:email, "is already taken")
    else
      return true
    end
    return false
  end

  def process_email
    return if @email_to_save.nil?
    self.emails.create(:address => @email_to_save)
    @email_to_save = nil
  end
  private :preprocess_email, :process_email


  ######### EMAIL SHORTCUTS ##########

  def self.create_and_activate(attrs={})
    u = User.new(attrs)
    u.user_state = 'active'
    u.save && Email.find_by_address(attrs[:email]).activate!
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

  def iphone_balances
    @xml = Builder::XmlMarkup.new(:indent => 2)
    @xml.instruct! :xml, :version => "1.0"

    @xml.balances(:type => 'array') {
      for balance in balances.sort_by{ |b| b[:balance]}.reverse
        @xml.balance {
          @xml.balance(balance[:balance])
          @xml.user_id(balance[:user].id)
          @xml.name(balance[:user].name)
          @xml.email(balance[:user].primary_email.address)
        }
      end
    }
  end

  def transactions_with(user_id)
    @xml = Builder::XmlMarkup.new(:indent => 2)
    @xml.instruct! :xml, :version => "1.0"

    user = User.find_by_id(user_id)
    if user
      transactions = (self.credits.to_user(user) + self.debts.from_user(user)).sort_by{ |t| t.created_at}.reverse
      @xml.balances(:type => 'array') {
        for transaction in transactions
          @xml.transaction {
            @xml.amount(transaction.amount)
            @xml.creditor_email(transaction.creditor_email)
            @xml.debtor_email(transaction.debtor_email)
            @xml.created_at(transaction.created_at.strftime("%a %b %d, %Y"))
            @xml.description(transaction.description)
          }
        end
      }
    else
      []
    end
  end

  def nomworth
    credits.sum(:amount) - debts.sum(:amount)
  end

  def transfer_transactions_to(user)
    self.credits.update_all("creditor_id = #{user.id}")
    self.debts.update_all("debtor_id = #{user.id}")
  end

end
