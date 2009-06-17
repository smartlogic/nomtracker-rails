require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase
  
  should_belong_to :user
  should_validate_presence_of :address, :user_id
  
end
