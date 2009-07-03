class MoveActivationCodeFromUsersToEmails < ActiveRecord::Migration
  def self.up
    # move existing email addresses from users to emails
    User.all.each do |user|
      e = Email.new(:user => user, :email => user.email)
      e.email_state = 'active' if user.active?
      e.activation_code = user.activation_code
      e.save!
    end

    remove_column :users, :email
    remove_column :users, :activation_code

    add_column :emails, :email_state, :string, :limit => 30, :nil => false

    add_column :emails, :activation_code, :string, :limit => 40
    
    remove_column :emails, :verified
  end

  def self.down
  end
end
