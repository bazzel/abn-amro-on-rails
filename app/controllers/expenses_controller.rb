class ExpensesController < ApplicationController
  before_filter :find_upload, :find_bank_account
  before_filter :find_expense, :only => [:edit, :update]

  # GET "/bank_accounts/1/expenses/index"s
  def index
    @expenses = @bank_account.expenses.order('expenses.transaction_date DESC').includes(:bank_account)
    @categories_chart = CategoriesChart.new(@bank_account)

    if params[:upload_id]
      @bank_accounts = @upload.bank_accounts
      @expenses = @expenses.joins(:upload_detail).where('upload_id = ?', params[:upload_id])
    else
      @bank_accounts = BankAccount.all
    end

    @expenses = @expenses.paginate :page => params[:page], :per_page => 25
  end

  # GET "/bank_accounts/1/expenses/100/edit"
  def edit
    # Edit view contains several forms for different resources (.e.g. category).
    # Submitting these forms must redirect/render to this edit action.
    # See POST categories for usage of this postback_url.
    @pass_through[:postback_url] = edit_bank_account_expense_path(@bank_account, @expense)
    @category = Category.new
    @preset = Preset.new
  end

  # PUT "/bank_accounts/1/expense/100"
  def update
    @expense.update_attributes(params[:expense])
    redirect_to bank_account_expenses_path(@bank_account, @pass_through), :notice => 'Expense was successfully updated'
  end

  # PUT "/bank_accounts/1/expense/presets"
  def presets
    response_status_and_flash = {}

    if (ids = params[:expense_ids])
      expenses = @bank_account.expenses.find(params[:expense_ids])
      applied = Preset.apply_to(expenses)
      response_status_and_flash[:notice] = t(:'flash.expenses.presets', :count => applied)
    else
      response_status_and_flash[:alert] = 'Please select one or more expenses and try again.'
    end

    redirect_to bank_account_expenses_path(@bank_account, @pass_through), response_status_and_flash
  end

  private
  def find_bank_account
    @bank_account ||=
      begin
        if params[:bank_account_id]
          @bank_account = BankAccount.find(params[:bank_account_id])
        elsif params[:upload_id]
          @bank_account = @upload.bank_accounts.first
        else
          @bank_account = BankAccount.first
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

  def find_expense
    @expense = @bank_account.expenses.find(params[:id])
  end
end
