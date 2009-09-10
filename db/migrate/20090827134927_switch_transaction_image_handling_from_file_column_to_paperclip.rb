class SwitchTransactionImageHandlingFromFileColumnToPaperclip < ActiveRecord::Migration
  def self.up
    remove_column :transactions, :image
    add_column :transactions, :image_file_name, :string
    add_column :transactions, :image_content_type, :string
    add_column :transactions, :image_file_size, :string
    add_column :transactions, :image_updated_at, :string
  end

  def self.down
    remove_column :transactions, :image_file_name, :string
    remove_column :transactions, :image_content_type, :string
    remove_column :transactions, :image_file_size, :string
    remove_column :transactions, :image_updated_at, :string
  end
end
