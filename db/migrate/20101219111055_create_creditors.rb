class CreateCreditors < ActiveRecord::Migration
  def self.up
    create_table :creditors do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :creditors
  end
end
