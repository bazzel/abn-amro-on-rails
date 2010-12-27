class CreditorsController < ApplicationController
  before_filter :find_creditor, :only => [:edit, :update, :show, :destroy]

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
  end

  # PUT creditors/1
  def update
    if @creditor.update_attributes(params[:creditor])
      redirect_to creditors_path(@pass_through), :notice => 'Creditor was successfully updated'
    else
      render :edit
    end
  end

  # GET creditors/1
  #
  # This will show a confirmation view for users who have javascript disabled.
  def show
    if params[:destroy]
      render :confirm_destroy and return
    end
  end

  # DELETE creditors/1
  def destroy
    @creditor.destroy
    redirect_to creditors_path(@pass_through), :notice => 'Creditor was successfully destroyed'
  end

  private
    def find_creditor
      @creditor = Creditor.find(params[:id])
    end
end