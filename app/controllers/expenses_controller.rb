class ExpensesController < ApplicationController
  
  def index
    @upload = Upload.find(params[:upload_id])
    @expenses = @upload.expenses
  end
end
