require File.dirname(__FILE__) + '/../test_helper'

# custom shoulda macro
def should_require(field)
  should "require #{field}" do
    @user.send(field.to_s + '=', nil)
    assert_no_difference 'User.count' do
      @user.save
      assert @user.errors.on(field)
    end
  end
end

def should_not_allow_add_email_to_be_invoked
  should "not allow #add_email to be invoked" do
    assert_raise(NoMethodError) { !@user.add_email("john2@slsdev.net") }
  end
end

class UserTest < ActiveSupport::TestCase

  subject { Factory(:user) }

  should have_many :transactions
  should have_many :emails

  context "When assigning an email address that does not already exist in the database" do

    should_change 'Email.count', :by => 1
    should_change 'User.count', :by => 1

    should "create a user john that can register and be activated" do
      assert_nothing_raised { subject.register! && subject.activate! }
    end

    should "create a user john with 1 email address" do
      assert_equal 1, subject.emails.size
    end

    should "set john@slsdev.net as the primary_email" do
      assert_equal "john@slsdev.net", @john.primary_email.address
    end
  end

  context "When the email john@slsdev.net already exists in the database" do
    setup do
      @john = Factory(:user)
      #create_john
    end

    context "and we try to create a new user joseph with that same email address" do
      setup do
        @joseph = Factory.build(:user)
        @joseph.save
      end

      should_change 'Email.count', :by => 0
      should_change 'User.count', :by => 0

      should "have an error on the user object" do
        assert @joseph.errors.on(:email)
      end
    end

  end

  context "When the email address john@slsdev.net is not registered in the system and User#find_by_email is called" do
    setup do
      @user = User.find_by_email('john@slsdev.net')
    end

    should "return nil" do
      assert_nil @user
    end
  end

  context "When the email address john@slsdev.net is registered in the system and User#find_by_email is called" do
    setup do
      temp = Factory(:user, :email => 'john@slsdev.net')
      @user = User.find_by_email("john@slsdev.net")
    end

    should "return john" do
      assert_not_nil @user
      assert @user.is_a?(User)
      assert @user.emails.map(&:address).include?("john@slsdev.net")
    end
  end

  context "When a user john has debits of 5 and 10 and a credit of 8, john" do
    setup do
      @john = Factory(:user, :name => 'john', :email => 'john@slsdev.net')
      Transaction.create!(:creditor => nick, :debtor => @john, :amount => 5.0)
      Transaction.create!(:creditor => nick, :debtor => @john, :amount => 10.0)
      Transaction.create!(:creditor => @john, :debtor => nick, :amount => 8.0)
    end

    should "have three transactions" do
      assert_equal 3, @john.transactions.count
    end

    should "have transactions that sum to -$7" do
      assert_equal -7.0, @john.transactions.sum(:amount)
    end
  end

  context "When a new User object has been instantiated" do
    setup do
      @user = User.new
    end

    should "default to :unregistered user_state" do
      assert_equal "unregistered", @user.user_state
    end

    should "only require an email address to support ad hoc debt creation" do
      @user.email = 'joe@slsdev.net'
      assert_difference 'User.with_user_state(:unregistered).count' do
        @user.save
        assert !@user.new_record?, "#{@user.errors.full_messages.to_sentence}"
      end
    end

    should "not be able to authenticate after being persisted to the database" do
      @user.email = 'joe@slsdev.net'
      @user.save!
      assert !User.authenticate(@user.primary_email.address, 'wrong password'), "A :pending user should not be able to authenticate"
    end

  end

  context "When a user is :unregistered" do
    setup do
      @user = User.new(:email => 'john@slsdev.net')
    end

    should "be able to transition to pending after saving name and password" do
      @user.attributes = {:password => 'johnjohn', :password_confirmation => 'johnjohn', :name => 'John'}
      @user.register!
      assert_equal 'pending', @user.user_state
    end

    should "not be able to authenticate after being persisted to the database" do
      @user.save!
      assert !User.authenticate(@user.primary_email.address, create_user_attrs[:password]), "A :pending user should not be able to authenticate"
    end

    should_not_allow_add_email_to_be_invoked

  end

  context "When a user is :pending" do
    setup do
      @user = User.new(:email => 'john@slsdev.net', :password => 'johnjohn', :password_confirmation => 'johnjohn', :name => 'John')
      @user.user_state = 'pending'
    end

    should "be able to transition to :active" do
      @user.activate!
      assert_equal 'active', @user.user_state
    end

    should_require(:password)
    should_require(:password_confirmation)
    should_require(:name)

    should "not be able to authenticate after being persisted to the database" do
      @user.save!
      assert !User.authenticate(@user.primary_email.address, create_user_attrs[:password]), "A :pending user should not be able to authenticate"
    end

    should_not_allow_add_email_to_be_invoked

  end

  context "When a user is :active" do

    setup do
      @user = Factory(:active_user)
    end

    should_require(:name)

    should "be able to authenticate" do
      puts @user.user_state
      puts @user.primary_email.address
      puts @user.primary_email.active
      assert User.authenticate(@user.primary_email.address, 'password'),
             "An :active user should be able to authenticate"
    end

    should "allow #add_email to be invoked" do
      assert_nothing_raised { @user.add_email("john2@slsdev.net") }
    end

    context "and has a pending email address" do
      setup do
        @user.emails.create!(:address => 'john2@slsdev.net')
      end

      should "not allow authentication with the pending email address" do
        assert_nil User.authenticate('john2@slsdev.net', 'johnjohn'),
                   "A :pending email should not be acceptable when trying to authenticate"
      end
    end

  end

  context "A user nick has made transactions with users adam and mike but not john, so his network" do
    setup do
      @nick = Factory(:user, :name => 'nick', :email => 'nick@slsdev.net', :user_state => 'active')
      @adam = Factory(:user, :name => 'adam', :email => 'adam@slsdev.net')
      @mike = Factory(:user, :name => 'mike', :email => 'mike@slsdev.net')
      @john = Factory(:user, :name => 'john', :email => 'john@slsdev.net')

      Transaction.create!(:creditor => @nick, :debtor => @adam, :amount => 10)
      Transaction.create!(:creditor => @nick, :debtor => @mike, :amount => 50)
    end

    should "include adam" do
      assert @nick.network.include?(@adam.primary_email.address)
    end

    should "include mike" do
      assert @nick.network.include?(@mike.primary_email.address)
    end

    should "not include john" do
      assert !@nick.network.include?(@john.primary_email.address)
    end
  end

  context "When a user nick has made transactions of +10, -40, and +50 with john" do
    setup do
      @john = Factory(:user)
      @nick = Factory(:user, :name => 'nick', :email => 'nick@slsdev.net', :user_state => 'active')

      Transaction.create!(:creditor => @nick, :debtor => @john, :amount => 10)
      Transaction.create!(:creditor => @john, :debtor => @nick, :amount => 40)
      Transaction.create!(:creditor => @nick, :debtor => @john, :amount => 50)
    end

    should "have a balance of $20 for nick" do
      assert_equal(20.0, nick.balance_with(@john))
    end

    should "have a balance of -$20 for john" do
      assert_equal(-20.0, @john.balance_with(nick))
    end

    should "include john in nick's list of balances" do
      assert !nick.balances.detect {|balance| balance[:user] == @john && balance[:balance] == 20.0}.nil?
    end

    should "include nick in john's list of balances" do
      assert !@john.balances.detect {|balance| balance[:user] == nick && balance[:balance] == -20.0}.nil?
    end
  end

  context "When a user nick has made transactions of -10 and 10 with john" do
    setup do
      @john = create_john
      Transaction.create!(:creditor => nick, :debtor => @john, :amount => 10)
      Transaction.create!(:creditor => @john, :debtor => nick, :amount => 10)
    end

    should "have a balance of $0 for nick" do
      assert_equal 0.0, nick.balance_with(@john)
    end

    should "have a balance of $0 for john" do
      assert_equal 0.0, @john.balance_with(nick)
    end

    should "not include john in nick's list of balances" do
      assert nick.balances.detect {|balance| balance[:user] == @john}.nil?
    end

    should "not include nick in john's list of balances" do
      assert @john.balances.detect {|balance| balance[:user] == nick}.nil?
    end
  end

  context "When passing an email to User.create_and_activate" do
    setup do
      @john = User.create_and_activate(john_attrs)
    end

    should_change 'Email.count', :by => 1
    should_change 'Email.with_email_state(:active).count', :by => 1
    should_change 'User.count', :by => 1
    should_change 'User.with_user_state(:active).count', :by => 1

    should "create john with a single email address" do
      u = User.find(@john.id)
      assert_equal john_attrs[:name], u.name
      assert_equal 1, u.emails.size
      assert_equal john_attrs[:email], u.emails.first.address
    end

    should "set the email as the primary_email address" do
      u = User.find(@john.id)
      assert_equal john_attrs[:email], u.primary_email.address
    end
  end

  context "When a user john has 1 debt and 1 credit" do
    setup do
      @john = create_john
      Transaction.create!(:creditor => @john, :debtor => nick, :amount => 5)
      Transaction.create!(:debtor => @john, :creditor => nick, :amount => 10)
    end

    context "and we want to transfer john's transactions to adam" do
      setup do
        @john.transfer_transactions_to(adam)
      end

      should_change "adam.transactions.count", :by => 2
      should_change "@john.transactions.count", :by => -2
      should_change "Transaction.count", :by => 0
    end
  end

  context "When a user nick has 2 emails on his account" do
    setup do
      nick.emails.create!(:address => 'nick2@slsdev.net')
    end

    context "and we #destroy his account" do
      setup do
        nick.destroy
      end

      should_change 'User.count', :by => -1
      should_change 'Email.count', :by => -2
    end
  end

  context "When authenticating using an email that doesn't exist in the database" do
    setup do
      @return = User.authenticate('jtrupiano@slsdev.net', 'john')
    end

    should "return nil" do
      assert_nil @return
    end
  end

  ######## NOMWORTH #########

  # This will need to change when we add the functionality to resolve debts
  def test_nomworth_is_the_sum_of_transaction_amounts_for_a_user
    nick.stubs(:credits).returns(mock(:sum => 110.0))
    nick.stubs(:debts).returns(mock(:sum => 50.0))
    assert_equal 60.0, nick.nomworth
  end

  ######## NOMWORTH ##########

  def test_should_reset_password
    adam.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal adam, User.authenticate(adam.primary_email.address, 'new password')
  end

  def test_should_not_rehash_password
    adam.update_attributes(:name => 'Adam 2')
    assert_equal adam, User.authenticate('adam@slsdev.net', 'adamadam')
  end

  def test_should_set_remember_token
    adam.remember_me
    assert_not_nil adam.remember_token
    assert_not_nil adam.remember_token_expires_at
  end

  def test_should_unset_remember_token
    adam.remember_me
    assert_not_nil adam.remember_token
    adam.forget_me
    assert_nil adam.remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    adam.remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil adam.remember_token
    assert_not_nil adam.remember_token_expires_at
    assert adam.remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    adam.remember_me_until time
    assert_not_nil adam.remember_token
    assert_not_nil adam.remember_token_expires_at
    assert_equal adam.remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    adam.remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil adam.remember_token
    assert_not_nil adam.remember_token_expires_at
    assert adam.remember_token_expires_at.between?(before, after)
  end

end
