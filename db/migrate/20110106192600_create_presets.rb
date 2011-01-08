class CreatePresets < ActiveRecord::Migration
  def self.up
    create_table :presets do |t|
      t.string :keyphrase
      t.integer :creditor_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :presets
  end
end
