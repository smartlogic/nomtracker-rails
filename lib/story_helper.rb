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
  
    adam = User.create_and_activate(:name => "Adam", :password => 'adamadam',:password_confirmation => 'adamadam', :email => "adam@slsdev.net", :wants_to_be_notified => true)
    nick = User.create_and_activate(:name => "Nick", :password => 'nicknick', :password_confirmation => 'nicknick', :email => "nick@slsdev.net", :wants_to_be_notified => true)
    michael = User.create_and_activate(:name => "Michael", :password => 'mikemike', :password_confirmation => 'mikemike', :email => "michael@slsdev.net", :wants_to_be_notified => true)

    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 5, :description => "pizza", :image => dev_image)
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 2, :description => "pizza")
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 2.50, :description => "poker")
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 3.25, :description => "lunch", :image => dev_image)
    Transaction.create!(:creditor => adam, :debtor => nick, :amount => 1.25, :description => "pizza")

    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 1.25, :description => "chipotle")
    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 2, :description => "pizza")
    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 3.25, :description => "chinese food", :image => dev_image)
    Transaction.create!(:creditor => michael, :debtor => adam, :amount => 4.25, :description => "pizza")

    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 2.25, :description => "pizza")
    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 3.25, :description => "drinks", :image => dev_image("spreadsheet.png"))
    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 5.25, :description => "pizza")
    Transaction.create!(:creditor => nick, :debtor => michael, :amount => 9.25, :description => "subway")
  end

  # Purge the data that you loaded. Follows same pattern at purge_seed
  def self.purge_data
    self.purge_assets

    [Email, User, Transaction].reverse.each do |m|
      m.destroy_all
    end
  end

  def self.dev_image(image_name="rails.png")
    File.open(File.join(RAILS_ROOT, "public", "images", image_name))
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
