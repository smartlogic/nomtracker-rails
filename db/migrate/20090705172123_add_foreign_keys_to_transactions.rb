class AddForeignKeysToTransactions < ActiveRecord::Migration
  def self.up
    add_foreign_key :transactions, :creditor_id, :users, :id
    add_foreign_key :transactions, :debtor_id, :users, :id
    add_index :transactions, :creditor_id
    add_index :transactions, :debtor_id
  end

  def self.down
    # eh
  end
  
  private
    def self.add_foreign_key(tbl, column, ref_tbl, ref_column)
      ActiveRecord::Base.connection.execute("ALTER TABLE `#{tbl}` ADD FOREIGN KEY (#{column}) REFERENCES `#{ref_tbl}` (#{ref_column}) ON DELETE CASCADE")
    end
end
