class AddIndicesPartIi < ActiveRecord::Migration
  def self.up
    add_index :presets, :creditor_id
    add_index :presets, :category_id
  end

  def self.down
    remove_index :presets, :creditor_id
    remove_index :presets, :category_id
  end
end
class AddIndicesPartIi < ActiveRecord::Migration
  def self.up
    add_index :presets, :creditor_id
    add_index :presets, :category_id
  end

  def self.down
    remove_index :presets, :creditor_id
    remove_index :presets, :category_id
  end
end
