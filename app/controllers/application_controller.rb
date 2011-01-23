class ApplicationController < ActionController::Base
  before_filter :pass_through_params#, :only => [:index, :edit, :update, :new]

  protect_from_forgery

  private
    def pass_through_params
      # Include only the given keys.
      @pass_through = params.slice(:page, :roots, :search)
    end

    # Strips ids from postback_url,
    # finds their correspondings objects
    # and assigns them to instance variables.
    # The method returns a path which can be used
    # to call render :template.
    #
    # /bank_accounts/1/expenses/664/edit
    #
    # => @bank_account = #<BankAccount id: 1, ...>
    #    @expense = #<Expense id: 664, ..>
    #    returns expenses/edit
    def extract_template_from_url
      path = URI::split(params[:postback_url])[5]

      ids, routing = path.split('/').drop(1).partition{|e| e == "#{e.to_i}"}

      ids.each_with_index do |id, index|
        class_name = routing[index].camelize.singularize
        clazz = class_name.constantize
        instance_variable = "@#{routing[index].singularize}".to_sym
        instance_variable_set(instance_variable, clazz.find(id))
      end

      template = routing[-2,2].join('/')
      template
    end

end
