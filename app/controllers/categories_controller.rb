class CategoriesController < ApplicationController

  # GET categories/index
  # GET categories/index?roots=true
  def index
    if params[:roots]
      @categories = Category.roots
    else
      @categories = Category.children
    end

    @categories = @categories.paginate(:page => params[:page], :per_page => 25)
  end

  # GET categories/new
  def new
    @category = Category.new
  end

  # POST categories
  def create
    @category = Category.new(params[:category])

    if @category.save
      options = @category.parent ? {} : { :roots => true }
      redirect_to categories_path(options), :notice => 'Category was successfully created'
    else
      render :new
    end

  end
end