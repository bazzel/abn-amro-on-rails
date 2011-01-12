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
  # >> postback_url_unless(:controller => 'presets')
  # => <input id="postback_url" name="postback_url" type="hidden" value="/presets/new">
  def postback_url_unless(options = {})
    unless controller_name == options[:controller]
      hidden_field_tag :postback_url, @postback_url
    end
  end

  private
    def quotient(divisor, dividend)
      dividend == 0 ? 100 : (100 * divisor / dividend).abs.to_i
    end
end
