# Exposes methods that create dev and test data. Loads things from a "user story"
# perspective.
class StoryHelper
  self.extend StoryAccessors::Methods

  # load up the seed data for your application. This is data that should be loaded when the
  # application is deployed to a server for the first time. For example, an Admin account and
  # models like FileType that are database-level constants.
  #
  # This is best run as a series of calls to private methods:
  #   self.load_people
  #   self.load_posts
  # etc...
  def self.load_seed
  
  end
  
  # Purge the seed data that you loaded
  #
  # The best way to do this is as follows:
  #   [People, Posts, ... etc ].reverse.each do |model|
  #     model.destroy_all
  #   end
  # You should have an array of the models *in the same order* as in your load method. You should
  # have ALL of the models in the database in this table to be safe.
  def self.purge_seed
  
  end
  
  # Load up testing data for your test suite. Follows same pattern as load_seed
  def self.load_data
  
    adam= User.create!(:login => 'adam', :password => 'adamadam',:password_confirmation => 'adamadam', :email => "adam@a.com")
    nick= User.create!(:login => 'nick', :password => 'nicknick', :password_confirmation => 'nicknick', :email => "nick@a.com")
    michael= User.create!(:login => 'michael', :password => 'mikemike', :password_confirmation => 'mikemike', :email => "mike@a.com")

    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 5)
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 2)
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 2.50)
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 3.25)
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 1.25)

    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 1.25)
    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 2)
    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 3.25)
    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 4.25)
    
    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 2.25)
    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 3.25)
    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 5.25)
    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 9.25)
  end
  
  # Purge the data that you loaded. Follows same pattern at purge_seed
  def self.purge_data
    self.purge_assets

    [User, Transaction].reverse.each do |m|
      m.destroy_all
    end
  end

  private

  # Here you can run file system calls to clean out any content directories you use.
  # For example:
  # FileUtils.rm_rf(File.join(RAILS_ROOT, 'content', RAILS_ENV))
  def self.purge_assets
  
  end
  
  ### Put your Seed loading methods here:
  
  
  ### Put your data loading methods here:
  
  
end
