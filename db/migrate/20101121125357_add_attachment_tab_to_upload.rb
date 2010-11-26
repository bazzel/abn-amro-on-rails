class AddAttachmentTabToUpload < ActiveRecord::Migration
  def self.up
    add_column :uploads, :tab_file_name, :string
    add_column :uploads, :tab_content_type, :string
    add_column :uploads, :tab_file_size, :integer
    add_column :uploads, :tab_updated_at, :datetime
  end

  def self.down
    remove_column :uploads, :tab_file_name
    remove_column :uploads, :tab_content_type
    remove_column :uploads, :tab_file_size
    remove_column :uploads, :tab_updated_at
  end
end
