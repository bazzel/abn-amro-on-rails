class ExpensesController < ApplicationController
  
  before_filter :find_upload, :find_bank_account
  
  def index
    @expenses = @bank_account.expenses.includes(:bank_account)
    
    if params[:upload_id]
      @bank_accounts = @upload.bank_accounts
      @expenses = @expenses.joins(:upload_detail).where('upload_id = ?', params[:upload_id])
    else
      @bank_accounts = BankAccount.all
    end
  end
  
  private
  def find_bank_account
    @bank_account ||= 
      begin
        if params[:bank_account_id]
          @bank_account = BankAccount.find(params[:bank_account_id])
        elsif params[:upload_id]
          @bank_account = @upload.bank_accounts.first
        end
      end
  end
  
  def find_upload
    @upload ||= 
      begin
        if params[:upload_id]
          @upload = Upload.find(params[:upload_id])
        end
      end
  end
end
