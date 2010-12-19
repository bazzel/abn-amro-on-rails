class BankAccountsController < ApplicationController
  respond_to :xml, :json, :html
  
  def index
    @bank_accounts = BankAccount.all
    
    respond_with @bank_accounts
  end
  
  def edit
    @bank_account = BankAccount.find(params[:id])
  end
  
  def update
    @bank_account = BankAccount.find(params[:id])
    
    if @bank_account.update_attributes(params[:bank_account])
      redirect_to bank_accounts_path, :notice => 'Bank Account was successfully updated'
    else
      render :edit
    end
  end
  
end
