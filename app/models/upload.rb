class Upload < ActiveRecord::Base
  # === Constants
  XLS_CONTENT_TYPES = [
    'application/excel', 
    # 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', # spreadsheet does not support .xlsx
    'application/vnd.ms-excel'
  ]
  
  # === Validations
  validates_attachment_presence :xls, :message => 'This field is required. Please select a file.'
  validates_attachment_content_type :xls, :content_type => XLS_CONTENT_TYPES, :message => 'The file must be an Excel file. Please try again.'
  validates_attachment_size :xls, :less_than => 1.megabyte

  # Paperclip
  has_attached_file :xls, APP_CONFIG['upload']['xls']['has_attached_file_options'].symbolize_keys


end
