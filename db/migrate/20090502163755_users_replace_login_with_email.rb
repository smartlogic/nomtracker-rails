class UsersReplaceLoginWithEmail < ActiveRecord::Migration
  def self.up
    remove_column :users, :login
  end

  def self.down
    # eh
  end
end
