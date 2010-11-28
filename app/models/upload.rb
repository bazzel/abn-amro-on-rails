class Upload < ActiveRecord::Base
  # === Constants
  TAB_CONTENT_TYPES = ['text/plain']
  FILENAME_REGEX = /^txt(\d{6})(\d{6})\.tab$/i
  
  # === Validations
  validates_attachment_presence :tab, :message => 'This field is required. Please select a file.'
  validates_attachment_content_type :tab, :content_type => TAB_CONTENT_TYPES, :message => 'The file must be a Tab-delimited text file. Please try again.'
  validates_attachment_size :tab, :less_than => 1.megabyte
  validates_uniqueness_of :tab_file_name
  validates_format_of :tab_file_name, :with => FILENAME_REGEX, :allow_blank => true, :if => :valid_content_type?

  # Paperclip
  has_attached_file :tab, APP_CONFIG['upload']['tab']['has_attached_file_options'].symbolize_keys

  # Returns datetime part from filename 
  # formatted as DateTime.
  def downloaded_at
    md = FILENAME_REGEX.match(tab.original_filename)
    DateTime.parse("#{md[1]} #{md[2]}")
  end
  
  private
  def valid_content_type?
    errors[:tab_content_type].empty?
  end
end