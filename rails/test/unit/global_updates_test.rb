require File.dirname(__FILE__) + '/../test_helper'

class MockObject
  include GlobalUpdates
  
  attr_reader :current_user
  def initialize(user)
    @current_user = user
  end
end

class GlobalUpdatesTest < ActiveSupport::TestCase
  
  context "When a user is logged in" do
    setup do
      @obj = MockObject.new(nick)
    end
    
    should "return the user's nomworth" do
      assert_equal({:nomworth => nick.nomworth}, @obj.send(:global_updates))
    end
  end
  
  context "When a user is not logged in" do
    setup do
      @obj = MockObject.new(false)
    end
    
    should "raise an exception" do
      assert_raise(StandardError) { @obj.send(:global_updates) }
    end
  end
  
end
