class Upload < ActiveRecord::Base
  # === Constants
  XLS_CONTENT_TYPES = [
    'application/excel', 
    # 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', # spreadsheet does not support .xlsx
    'application/vnd.ms-excel',
    'application/vnd.ms-office'
  ]
  FILENAME_REGEX = /^xls(\d{12}).xls$/i
  
  # === Validations
  validates_attachment_presence :xls, :message => 'This field is required. Please select a file.'
  validates_attachment_content_type :xls, :content_type => XLS_CONTENT_TYPES, :message => 'The file must be an Excel file. Please try again.'
  validates_attachment_size :xls, :less_than => 1.megabyte
  validates_uniqueness_of :xls_file_name
  validates_format_of :xls_file_name, :with => FILENAME_REGEX, :allow_blank => true, :if => :valid_content_type?

  # Paperclip
  has_attached_file :xls, APP_CONFIG['upload']['xls']['has_attached_file_options'].symbolize_keys

  private
  def valid_content_type?
    errors[:xls_content_type].empty?
  end
end
