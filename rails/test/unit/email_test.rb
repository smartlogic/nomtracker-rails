require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase
  
  should_belong_to :user
  should_validate_presence_of :address, :user_id
  should_validate_uniqueness_of :address
  should_ensure_length_in_range :address, 6..100

  should_have_index :user_id
  should_have_index :address, :unique => true
  
  context "When an email is instantiated without any options" do
    setup do
      @email = Email.new
    end
    
    should "be in the :pending state" do
      assert @email.pending?
    end
  end
  
  context "When an email is :pending" do
    setup do
      @email = nick.emails.create!(:address => "nick2@slsdev.net")
    end
    
    should "have an activation code when saved" do
      assert_not_nil @email.activation_code
    end
  end
end
