class AddWantsToBeNotifiedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :wants_to_be_notified, :boolean, :null => false, :default => true
  end

  def self.down
    # why?
  end
end
