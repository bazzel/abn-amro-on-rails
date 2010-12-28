module CategoriesHelper

  # Creates a formtastic input element for category.
  # The element is disabled if a main category is edited.
  # The element does not contain a blank option if a subcategory is edited.
  def category_parent_input(form, category)
    options = {
      :collection => Category.roots,
      :include_blank => category.new_record? || !category.parent,
      :input_html => {
        :disabled => !category.new_record? && !category.parent
      }
    }

    form.input :parent, options
  end
end