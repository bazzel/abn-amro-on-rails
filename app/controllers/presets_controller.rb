class PresetsController < ApplicationController
  before_filter :find_preset, :only => [:edit, :update, :show, :destroy]

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
    @postback_url = new_preset_path
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
      @category = Category.new

      # Submitted from a form in the sidebar?
      if @postback_url = params[:postback_url]
        render :template => extract_template_from_url
      else
        @postback_url = new_preset_path
        render :new
      end
    end
  end

  # GET "presets/1"
  def edit
    @postback_url = edit_preset_path(@preset)
    @category = Category.new
  end

  # PUT "presets/1"
  def update
    if @preset.update_attributes(params[:preset])
      redirect_to presets_path(@pass_through), :notice => 'Preset was successfully updated'
    else
      @postback_url = edit_preset_path(@preset)
      @category = Category.new
      render :edit
    end
  end

  # GET "presets/1"
  #
  # This will show a confirmation view for users who have javascript disabled.
  def show
    if params[:destroy]
      render :confirm_destroy and return
    end
  end

  # DELETE "presets/1"
  def destroy
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

  private
    def find_preset
      @preset = Preset.find(params[:id])
    end
end