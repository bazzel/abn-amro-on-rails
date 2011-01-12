module ExpensesHelper

  def action_bar_section(*args, &block)
    action_bar = action_bar(*args)

    # concat action_bar
    # yield
    # concat action_bar

    action_bar + capture(&block) + action_bar
  end

  def action_bar(*args)
    content = content_tag(:div, submit_tag("Apply Presets"), :class => 'actions') + will_paginate(*args)
    content_tag(:div, content, :class => 'action-bars')
  end
end
