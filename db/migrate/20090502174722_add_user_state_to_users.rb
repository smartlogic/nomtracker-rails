class AddUserStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_state, :string, :limit => 30, :nil => false
  end

  def self.down
    # false
  end
end
