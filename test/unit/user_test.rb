require File.dirname(__FILE__) + '/../test_helper'

def should_require(field)
  should "require #{field}" do
    @user.send(field.to_s + '=', nil)
    assert_no_difference 'User.count' do
      @user.save
      assert @user.errors.on(field)
    end      
  end
end

class UserTest < ActiveSupport::TestCase

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
      assert !User.authenticate(@user.email, create_user_attrs[:password]), "A :pending user should not be able to authenticate"
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
        
    should_require(:email)

    should "not be able to authenticate after being persisted to the database" do
      @user.save!
      assert !User.authenticate(@user.email, create_user_attrs[:password]), "A :pending user should not be able to authenticate"
    end

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
    
    should_require(:email)
    should_require(:password)
    should_require(:password_confirmation)
    should_require(:name)

    should "not be able to authenticate after being persisted to the database" do
      @user.save!
      assert !User.authenticate(@user.email, create_user_attrs[:password]), "A :pending user should not be able to authenticate"
    end

  end
  
  context "When a user is :active" do
    
    setup do
      @user = User.new(:email => 'john@slsdev.net', :password => 'johnjohn', :password_confirmation => 'johnjohn', :name => 'John')
      @user.user_state = 'active'      
    end

    should_require(:email)
    should_require(:password)
    should_require(:password_confirmation)
    should_require(:name)

    should "be able to authenticate after being persisted to the database" do
      @user.save!
      assert User.authenticate(@user.email, 'johnjohn'), "A :pending user should not be able to authenticate"
    end
    
  end
  
  def test_should_reset_password
    adam.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal adam, User.authenticate(adam.email, 'new password')
  end

  def test_should_not_rehash_password
    adam.update_attributes(:email => 'adam2@slsdev.net')
    assert_equal adam, User.authenticate('adam2@slsdev.net', 'adamadam')
  end

  def test_should_authenticate_user
    assert_equal adam, User.authenticate(adam.email, 'adamadam')
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

protected
  def create_user(options = {})
    record = User.create_and_activate(create_user_attrs.merge(options))
    record
  end
  
  def create_user_attrs
    { :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69', :name => 'Quire' }
  end
end
