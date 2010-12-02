class CreateUploadDetails < ActiveRecord::Migration
  def self.up
    create_table :upload_details do |t|
      t.string :bankaccount
      t.string :currency
      t.date :transaction_date
      t.decimal :opening_balance, :precision => 8, :scale => 2
      t.decimal :ending_balance, :precision => 8, :scale => 2
      t.date :interest_date
      t.decimal :transaction_amount, :precision => 8, :scale => 2
      t.string :description
      
      t.references :upload
      
      t.timestamps
    end
  end

  def self.down
    drop_table :upload_details
  end
end