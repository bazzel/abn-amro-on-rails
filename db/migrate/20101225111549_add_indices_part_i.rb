class AddIndicesPartI < ActiveRecord::Migration
  def self.up
    add_index :categories, :parent_id
    add_index :expenses, :upload_detail_id
    add_index :expenses, :bank_account_id
    add_index :expenses, :creditor_id
    add_index :expenses, :category_id
    add_index :upload_details, :upload_id
  end

  def self.down
    remove_index :upload_details, :upload_id
    remove_index :expenses, :category_id
    remove_index :expenses, :creditor_id
    remove_index :expenses, :bank_account_id
    remove_index :expenses, :upload_detail_id
    remove_index :categories, :parent_id
  end
end
