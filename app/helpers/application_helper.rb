module ApplicationHelper

  def visual_amount(divisor, dividend)
    text = content_tag(:div, number_to_currency(divisor, :unit => ''), :class => 'balance-text')
    value = content_tag(:div, nil, :class => ['balance-value', divisor > 0 ? 'positive' : 'negative'].join(' '), :style => "width:#{quotient(divisor, dividend)}%;")

    content_tag(:div, text + value, :class => 'balance-container')
  end

  private
    def quotient(divisor, dividend)
      dividend == 0 ? 100 : (100 * divisor / dividend).abs.to_i
    end
end
