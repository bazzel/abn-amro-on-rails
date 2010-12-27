class CreditorsController < ApplicationController

  # GET creditors/index
  def index
    @creditors = Creditor.all.paginate(:page => params[:page], :per_page => 25)
  end

  # GET creditors/new
  def new
    @creditor = Creditor.new
  end

  # POST creditors
  def create
    @creditor = Creditor.new(params[:creditor])

    if @creditor.save
      redirect_to creditors_path, :notice => 'Creditor was successfully created'
    else
      render :new
    end
  end

  # GET creditors/1/edit
  def edit
    @creditor = Creditor.find(params[:id])
  end

  # PUT creditors/1
  def update
    @creditor = Creditor.find(params[:id])

    if @creditor.update_attributes(params[:creditor])
      redirect_to creditors_path(@pass_through), :notice => 'Creditor was successfully updated'
    else
      render :new
    end
  end

  # GET creditors/1
  #
  # This will show a confirmation view for users who have javascript disabled.
  def show
    @creditor = Creditor.find(params[:id])

    if params[:destroy]
      render :confirm_destroy and return
    end
  end

  # DELETE creditors/1
  def destroy
    @creditor = Creditor.find(params[:id])

    @creditor.destroy
    redirect_to creditors_path(@pass_through), :notice => 'Creditor was successfully destroyed'
  end
end