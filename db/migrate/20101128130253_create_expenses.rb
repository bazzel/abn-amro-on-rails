class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string :bankaccount
      t.date :transaction_date
      t.decimal :opening_balance, :precision => 8, :scale => 2
      t.decimal :ending_balance, :precision => 8, :scale => 2
      t.decimal :transaction_amount, :precision => 8, :scale => 2
      t.string :description
      
      t.references :upload_detail
      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
