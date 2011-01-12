class PresetsController < ApplicationController

  # GET "presets/index"
  def index
    @presets = Preset.all.paginate(:page => params[:page], :per_page => 25)
  end

  # GET "presets/new"
  def new
    @preset = Preset.new
    # Edit view contains several forms for different resources (.e.g. category).
    # Submitting these forms must redirect/render to this edit action.
    # See POST categories for usage of this postback_url.
    @pass_through[:postback_url] = new_preset_path
    @category = Category.new
  end

  # POST "presets"
  def create
    @preset = Preset.new(params[:preset])

    if @preset.save
      # If the category form in the sidebar is used,
      # we redirect to the postback_url instead of the index view.
      redirect_to (params[:postback_url] || presets_path), :notice => 'Preset was successfully created'
    else
      @pass_through[:postback_url] = new_preset_path
      @category = Category.new
      render :new
    end
  end

  # GET "presets/1"
  def edit
    @preset = Preset.find(params[:id])
    @pass_through[:postback_url] = edit_preset_path(@preset)
    @category = Category.new
  end

  # PUT "presets/1"
  def update
    @preset = Preset.find(params[:id])

    if @preset.update_attributes(params[:preset])
      redirect_to presets_path(@pass_through), :notice => 'Preset was successfully updated'
    else
      @pass_through[:postback_url] = edit_preset_path(@preset)
      @category = Category.new
      render :edit
    end
  end

  # GET "presets/1"
  #
  # This will show a confirmation view for users who have javascript disabled.
  def show
    @preset = Preset.find(params[:id])

    if params[:destroy]
      render :confirm_destroy and return
    end
  end

  # DELETE "presets/1"
  def destroy
    @preset = Preset.find(params[:id])
    @preset.destroy
    redirect_to presets_path(@pass_through), :notice => 'Preset was successfully destroyed'
  end

  # PUT "/presets/apply_multiple"
  def apply_multiple
    response_status_and_flash = {}

    if (ids = params[:preset_ids])
      presets = Preset.find(params[:preset_ids])
      applied = Preset.apply_for(presets)
      response_status_and_flash[:notice] = t(:'flash.presets.apply_multiple', :count => applied)
    else
      response_status_and_flash[:alert] = 'Please select one or more presets and try again.'
    end

    redirect_to presets_path, response_status_and_flash
  end


end