class AddDateAndDescriptionToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :when, :string, :size => 50
    add_column :transactions, :description, :string, :size => 255
  end

  def self.down
    remove_column :transactions, :when
    remove_column :transactions, :description
  end
end
