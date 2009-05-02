class RewordTransactionUsers < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :from_user_id, :creditor_id
    rename_column :transactions, :to_user_id, :debtor_id
  end

  def self.down
    rename_column :transactions, :creditor_id, :from_user_id
    rename_column :transactions, :debtor_id, :to_user_id
  end
end
