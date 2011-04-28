require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase

  subject { Factory(:email) }

  should belong_to :user
  should validate_presence_of :address
  should validate_uniqueness_of :address
  should ensure_length_of(:address).is_at_least(6).is_at_most(100)

  should have_db_index :user_id
  should have_db_index :address

  context "When an email is instantiated without any options" do
    
    should "be in the :pending state" do
      assert subject.pending?
    end
  end
  
  context "When an email is :pending" do
    setup do
      @user = Factory(:user)
      @email = @user.emails.create!(:address => "nick2@slsdev.net")
    end
    
    should "have an activation code when saved" do
      assert_not_nil @email.activation_code
    end
  end
  
  context "When creating an Email with an uppercase address" do
    setup do
      @user = Factory(:user)
      @email = @user.emails.create!(:address => "NICK2@SLSDEV.NET")
    end
    
    should "downcase the address before inserting into the database" do
      assert_equal "nick2@slsdev.net", Email.find(@email.id).address
    end
  end
end
