class CreateUploadDetails < ActiveRecord::Migration
  def self.up
    create_table :upload_details do |t|
      t.string :bankaccount
      t.string :currency
      t.date :transaction_date
      t.float :opening_balance
      t.float :ending_balance
      t.date :interest_date
      t.float :transaction_amount
      t.string :description
      
      t.references :upload
      
      t.timestamps
    end
  end

  def self.down
    drop_table :upload_details
  end
end