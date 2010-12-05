class ExpensesController < ApplicationController
  
  before_filter :find_bank_account
  
  def index
    @expenses = @bank_account.expenses.includes(:bank_account)
  end
  
  private
  def find_bank_account
    @bank_account ||= 
      begin
        if params[:bank_account_id]
          @bank_account = BankAccount.find(params[:bank_account_id])
        elsif params[:upload_id]
          @bank_account = Upload.find(params[:upload_id]).bank_accounts.first
        end
      end
  end
end
