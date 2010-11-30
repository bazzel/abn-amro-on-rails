class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :bankaccount
      t.date :transaction_date
      t.integer :opening_balance
      t.integer :ending_balance
      t.integer :transaction_amount
      t.string :description
      
      t.references :upload_detail
      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
