module FilterHelper

  # Creates a link tag of the creditor's name
  # and add the search options to the url extended with the creditor's id.
  # If the creditor's id is included in the search_attributes hash
  # then the id is removed from the hash.
  def link_to_filter(creditor, url, search_attributes)
    options = Rails.application.routes.recognize_path(url)
    html_options = {}

    if in_filter?(search_attributes, creditor)
      options = options.merge(withdraw_from_creditor(search_attributes, creditor))
      html_options[:class] = 'in_filter'
      html_options[:title] = "Remove filter on '#{creditor.name}'"
    else
      options = options.merge(extend_w_creditor(search_attributes, creditor))
    end

    content = link_to(creditor.name, url_for(options), html_options)

    content
  end

  private
    def extend_w_creditor(search_attributes, creditor)
      h = Marshal::load(Marshal.dump(search_attributes.symbolize_keys))
      h[:creditor_id_in] = ([h[:creditor_id_in]].flatten.compact << creditor.id).uniq
      { :search => h }
    end

    def withdraw_from_creditor(search_attributes, creditor)
      h = Marshal::load(Marshal.dump(search_attributes.symbolize_keys))
      h[:creditor_id_in].delete(creditor.id)
      h.delete_if { |k,v| v.empty? }

      h.empty? ? {} : { :search => h }
    end

    def in_filter?(search_attributes, creditor)
      (search_attributes.with_indifferent_access[:creditor_id_in] || []).include?(creditor.id)
    end
end