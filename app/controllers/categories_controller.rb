class CategoriesController < ApplicationController

  before_filter :find_category, :only => [:edit, :update, :show, :destroy]

  # GET "/categories/index"
  # GET "/categories/index?roots=true"
  def index
    if params[:roots]
      @categories = Category.roots
    else
      @categories = Category.children
    end

    @categories = @categories.paginate(:page => params[:page], :per_page => 25)
  end

  # GET "/categories/new"
  def new
    @category = Category.new
  end

  # POST "/categories"
  def create
    @category = Category.new(params[:category])

    if @category.save
      options = @category.parent ? {} : { :roots => true }
      # If the category form in the sidebar is used,
      # we redirect to the postback_url instead of the index view.
      redirect_to (params[:postback_url] || categories_path(options)), :notice => 'Category was successfully created'
    else
      @preset = Preset.new

      # Submitted from a form in the sidebar?
      if @postback_url = params[:postback_url]
        render :template => extract_template_from_url
      else
        @postback_url = new_category_path
        render :new
      end
    end

  end

  # GET "/categories/1/edit"
  def edit
  end

  # PUT "/categories/1"
  def update
    if @category.update_attributes(params[:category])
      redirect_to categories_path(@pass_through), :notice => 'Category was successfully updated'
    else
      render :edit
    end
  end

  # GET "/categories/1"
  #
  # This will show a confirmation view for users who have javascript disabled.
  def show
    if params[:destroy]
      render :confirm_destroy and return
    end
  end

  # DELETE "/categories/1"
  def destroy
    @category.destroy
    options = @category.parent ? {} : { :roots => true }

    redirect_to categories_path(options), :notice => 'Category was successfully destroyed'
  end

  private
    def find_category
      @category = Category.find(params[:id])
    end
end