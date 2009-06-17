class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails, :id => false do |t|
      t.string :address, :nil => false, :size => 100
      t.belongs_to :user, :nil => false
      t.bool :verified, :nil => false, :default => false
    end
    
    remove_column :users, :email
  end

  def self.down
    # who cares?
  end
end
