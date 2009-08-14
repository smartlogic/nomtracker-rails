class AddImageFieldToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :image, :string
  end

  def self.down
    remove_column :transactions, :image, :string
  end
end
