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

  # === Associations
  has_many :upload_details, :dependent => :destroy
  has_many :expenses, :through => :upload_details
  
  # Paperclip
  has_attached_file :tab, APP_CONFIG['upload']['tab']['has_attached_file_options'].symbolize_keys

  # === Callbacks
  # Paperclip saves the file in the after_save callback,
  # therefore we cannot process the file earlier (otherwise implement a custom Paperclip processor...)
  after_save :create_upload_details

  # Returns datetime part from filename 
  # formatted as DateTime.
  def downloaded_at
    md = FILENAME_REGEX.match(tab.original_filename)
    DateTime.parse("#{md[1]} #{md[2]}")
  end
  
  def bank_accounts
    BankAccount.joins({:expenses => :upload_detail})
      .where('upload_id = ?', id)
      .group(:bank_account_id)  
  end
  
  private
  def valid_content_type?
    errors[:tab_content_type].empty?
  end
  
  def create_upload_details
    # We only want to process the TAB file once.
    if upload_details.empty?
      # We should probably wrap this in a transaction:
      # Upload.transaction(:requires_new => true) do
      #   ...
      # end
      Parsers::TabParser.foreach(tab.path) do |row|
        attributes = row.to_hash
        logger.debug("[#{self.class}#create_upload_details] Instantiate a new UploadDetail object from the following attributes:\n#{attributes.to_yaml}")
        upload_details.create attributes
      end
    end
  end
  
end
