class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :address, :nil => false, :size => 100
      t.belongs_to :user, :nil => false
      t.boolean :verified, :nil => false, :default => false
    end
    
    add_index :emails, :address, :unique => true
    add_index :emails, :user_id
    
    remove_column :users, :email
  end

  def self.down
    # who cares?
  end
end
