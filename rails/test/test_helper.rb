ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'story_helper'
require 'shoulda'
require 'rr'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  # self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  # self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Commonly accessed db objects
  include StoryAccessors::Methods
end

class ActionController::TestCase
  extend StoryAccessors::Methods  # this probably isn't the right thing to do....
  include AuthenticatedTestHelper
  
  def load_session
    # allows us to use the self.log_in function to log in a certain user
    @scoped_session = {}
  end

  def teardown
    log_out
  end
  
  # Used as a directive at the top of a functional test (to blanket log in this user)
  def log_in(user)
    @scoped_session.merge!({:user_id => user.id})
  end

  def log_out
    @scoped_session.delete(:user_id)
  end

  [:get, :post, :put, :delete].each do |meth|
    src = <<-END_OF_SRC
      def #{meth.to_s}(action, parameters = nil, session = {}, flash = nil)
        super(action, parameters, session.merge(@scoped_session || {}), flash)
      end
    END_OF_SRC
    class_eval src, __FILE__, __LINE__
  end

  def xhr(request_method, action, parameters = nil, session = {}, flash = nil)
    super(request_method, action, parameters, session.merge(@scoped_session || {}), flash)
  end
end
