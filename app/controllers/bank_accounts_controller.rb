class BankAccountsController < ApplicationController
  respond_to :xml, :json, :html

  before_filter :find_bank_account, :only => [:edit, :update]

  def index
    @bank_accounts = BankAccount.all

    respond_with @bank_accounts
  end

  def edit
  end

  def update
    if @bank_account.update_attributes(params[:bank_account])
      redirect_to bank_accounts_path, :notice => 'Bank Account was successfully updated'
    else
      render :edit
    end
  end

  private
  def find_bank_account
    @bank_account = BankAccount.find(params[:id])
  end
end


# module ActionView::Helpers::UrlHelper
#   def url_for
#
#   end
# end