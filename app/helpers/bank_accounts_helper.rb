module BankAccountsHelper

  # <div class="balance-container">
  #   <div class="balance-text"> 152.24</div>
  #   <div class="balance-value positive" style="width:26%;"></div>
  # </div>
  def balance_for(bank_account)
    text = content_tag(:div, number_to_currency(bank_account.balance, :unit => ''), :class => 'balance-text')
    value = content_tag(:div, nil, :class => ['balance-value', bank_account.balance.positive? ? 'positive' : 'negative'].join(' '), :style => "width:#{(bank_account.quotient * 100).to_i}%;")
    
    content_tag(:div, text + value, :class => 'balance-container')
  end
end
