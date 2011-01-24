module HiddenFieldsHelper
  # Source: http://marklunds.com/articles/one/314
  #
  # Rails Workaround: Preserving Nested Hash Params With List Values Across Requests
  #
  # Suppose you have an HTML search form with a multi-valued select 
  # with the name "person[personal][interests][]". 
  # The trailing brackets are there to indicate to rails 
  # that this HTTP parameter should be converted to a Ruby list. 
  # Now, suppose the form submits to the search action in the contacts controller. 
  # Our params hash will then contain:
  #
  #  params = {
  #    :controller => 'contacts',
  #    :action => 'search',
  #    :person => {
  #      :personal => {
  #        :interests => ['music', 'chess']
  #      }
  #    }
  #  }
  # So far so good. 
  #
  # Now suppose you have pagination links on the search results page 
  # and also that you want to provide a link or button 
  # back to the search form for refining the search criteria. 
  # Here come the bad news - url_for which is used to create links 
  # doesn't support nested hash parameters and 
  # also doesn't support list values 
  # (there are some patches already to address at least the nesting problem). 
  #
  # Here is what url_for produces in this case:
  #
  #  > puts CGI.unescape(url_for(params))
  #  > /contacts/search/?person=personalinterestsmusicchess
  # Clearly url_for is inadequate in this case. I (Peter Marklund) have written 
  # a set of helper methods to help save the day:
  # 
  def flatten_hash(hash = params, ancestor_names = [])
    flat_hash = {}
    hash.each do |k, v|
      names = Array.new(ancestor_names)
      names << k
      if v.is_a?(Hash)
        flat_hash.merge!(flatten_hash(v, names))
      else
        key = flat_hash_key(names)
        key += "[]" if v.is_a?(Array)
        flat_hash[key] = v
      end
    end

    flat_hash
  end

  def flat_hash_key(names)
    names = Array.new(names)
    name = names.shift.to_s.dup 
    names.each do |n|
      name << "[#{n}]"
    end
    name
  end

  def hash_as_hidden_fields(hash = params)
    hidden_fields = []
    flatten_hash(hash).each do |name, value|
      value = [value] if !value.is_a?(Array)
      value.each do |v|
        hidden_fields << hidden_field_tag(name, v.to_s, :id => nil) 
      end
    end

    hidden_fields.join("\n").html_safe
  end
  
end
