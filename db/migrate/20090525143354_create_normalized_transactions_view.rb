require 'rails_sql_views'

class CreateNormalizedTransactionsView < ActiveRecord::Migration
  def self.up
    sql = <<-SQL
      (SELECT `id`, `creditor_id` AS `me`, `debtor_id` AS `you`, `amount`, `created_at`, `updated_at`, `when`, `description` FROM `transactions`) 
      UNION 
      (SELECT `id`, `debtor_id` AS `me`, `creditor_id` AS `you`, `amount` * -1 AS `amount`, `created_at`, `updated_at`, `when`, `description` FROM transactions)
    SQL
    create_view :normalized_transactions, sql do |t|
      t.column :id
      t.column :me
      t.column :you
      t.column :amount
      t.column :created_at
      t.column :updated_at
      t.column :when
      t.column :description
    end
  end

  def self.down
    drop_view :normalized_transactions
  end
end
