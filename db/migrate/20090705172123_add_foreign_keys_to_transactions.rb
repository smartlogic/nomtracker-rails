class AddForeignKeysToTransactions < ActiveRecord::Migration
  def self.up
    add_foreign_key :transactions, :creditor_id, :users, :id
    add_foreign_key :transactions, :debtor_id, :users, :id
    add_foreign_key :emails, :user_id, :users, :id
    add_index :transactions, :creditor_id
    add_index :transactions, :debtor_id
    
    # XXX: CREATE SECURITY INVOKER VIEW normalized_transactions AS 
    sql = <<-SQL
      CREATE VIEW normalized_transactions AS 
        (SELECT id, creditor_id AS me, debtor_id AS you, amount, created_at, updated_at, 'when', description FROM transactions) 
        UNION 
        (SELECT id, debtor_id AS me, creditor_id AS you, amount * -1 AS amount, created_at, updated_at, 'when', description FROM transactions)
    SQL
    
    ActiveRecord::Base.connection.execute("DROP VIEW normalized_transactions")
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.down
    # eh
  end
  
  private
    def self.add_foreign_key(tbl, column, ref_tbl, ref_column)
      ActiveRecord::Base.connection.execute("ALTER TABLE #{tbl} ADD FOREIGN KEY (#{column}) REFERENCES #{ref_tbl} (#{ref_column}) ON DELETE CASCADE")
    end
end
