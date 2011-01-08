class PresetsController < ApplicationController

  # GET "presets/index"
  def index
    @presets = Preset.all.paginate(:page => params[:page], :per_page => 25)
  end

  # GET "presets/new"
  def new
    @preset = Preset.new
  end

  # POST "presets"
  def create
    @preset = Preset.new(params[:preset])

    if @preset.save
      redirect_to presets_path, :notice => 'Preset was successfully created'
    else
      render :new
    end
  end

  # GET "presets/1"
  def edit
    @preset = Preset.find(params[:id])
  end

  # PUT "presets/1"
  def update
    @preset = Preset.find(params[:id])

    if @preset.update_attributes(params[:preset])
      redirect_to presets_path(@pass_through), :notice => 'Preset was successfully updated'
    else
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

end