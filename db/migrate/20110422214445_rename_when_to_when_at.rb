class RenameWhenField < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :when, :when_at
    drop_view :normalized_transactions

    sql = <<-SQL
      (SELECT id, creditor_id AS me, debtor_id AS you, amount, created_at, updated_at, when_at, description FROM transactions)
      UNION
      (SELECT id, debtor_id AS me, creditor_id AS you, amount * -1 AS amount, created_at, updated_at, when_at, description FROM transactions)
    SQL
    create_view :normalized_transactions, sql do |t|
      t.column :id
      t.column :me
      t.column :you
      t.column :amount
      t.column :created_at
      t.column :updated_at
      t.column :when_at
      t.column :description
    end

  end

  def self.down
    rename_column :transactions, :when_at, :when
    drop_view :normalized_transactions
    sql = <<-SQL
      (SELECT id, creditor_id AS me, debtor_id AS you, amount, created_at, updated_at, "when", description FROM transactions)
      UNION
      (SELECT id, debtor_id AS me, creditor_id AS you, amount * -1 AS amount, created_at, updated_at, "when", description FROM transactions)
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
end
