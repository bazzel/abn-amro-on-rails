class BankAccountsController < ApplicationController
  
  def index
    @bank_accounts = BankAccount.all
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
