module ApplicationHelper

  def visual_amount(divisor, dividend)
    text = content_tag(:div, number_to_currency(divisor, :unit => ''), :class => 'balance-text')
    value = content_tag(:div, nil, :class => ['balance-value', divisor > 0 ? 'positive' : 'negative'].join(' '), :style => "width:#{quotient(divisor, dividend)}%;")

    content_tag(:div, text + value, :class => 'balance-container')
  end

  # Returns a hidden field tag with @postback_url (set in controller)
  # unless the url is created by an action in the current controller.
  #
  # controller:
  # @postback_url = new_preset_path
  # view:
  # >> postback_url(:controller => 'presets')
  # => <input id="postback_url" name="postback_url" type="hidden" value="/presets/new">
  def postback_url(options = {})
    if must_be_a_sidebar?(options)
      hidden_field_tag :postback_url, @postback_url
    end
  end

  # If @postback_url is set, we probably have an extra form
  # in the view to provide an easy way to submit data
  # which we need in the main form but it not yet present.
  # This method returns true if the partial from which it's called from
  # is (probably) rendered anywhere else then in the 'main' view,
  # e.g. the sidebar.
  def must_be_a_sidebar?(options = {})
    @postback_url && @postback_url !~ /#{options[:controller] || controller_name}/
  end

  def li_active_unless(content, options = {})

    if params[:postback_url]
      path = URI::split(params[:postback_url])[5]
      controller = path.split('/').delete_if{|e| e == "#{e.to_i}"}
      controller = controller[-2]
    end

    if (controller && controller =~ /#{options[:controller]}/) || (!params[:postback_url] && controller_name =~ /#{options[:controller]}/)
      content_tag_options = {:class => 'active'}
    else
      content_tag_options = {}
    end

    content_tag(:li, content, content_tag_options)
  end

  private
    def quotient(divisor, dividend)
      dividend == 0 ? 100 : (100 * divisor / dividend).abs.to_i
    end
end
