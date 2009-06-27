require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase
  
  should_belong_to :user
  should_validate_presence_of :address, :user_id
  should_validate_uniqueness_of :address
  should_ensure_length_in_range :address, 6..100

  should_have_index :user_id
  should_have_index :address, :unique => true
end
