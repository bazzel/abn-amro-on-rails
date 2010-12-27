class ApplicationController < ActionController::Base
  before_filter :pass_through_params#, :only => [:index, :edit, :update, :new]

  protect_from_forgery

  private
  def pass_through_params
    @pass_through = params.slice(:page, :roots)
  end

end
