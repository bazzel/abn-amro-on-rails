module TemplateHelper
  # This helper method is borrowed from Dr. Nic.
  # See http://drnicwilliams.com/2009/10/06/install-any-html-themetemplate-into-your-rails-app/ for more info.
  #
  # ...
  # Use <% content_for :menu do %> ... <% end %> from any view template
  # Create a _menu.html.erb partial in your controller’s views folder, e.g. app/views/posts/_menu.html.erb
  # Modify the _menu.html.erb partial in the app/views/layouts folder. This is the default source.
  #
  # Put the following line in your view:
  #   <%= yield(:menu) || render_or_default('menu') %>
  # The yield(:menu) enables the content_for helper to override the partials.
  def render_or_default(partial, default = partial)
    p "*"*100
    render :partial => partial
  rescue ActionView::MissingTemplate
    begin
      render :partial => "layouts/#{default}"
    rescue ActionView::MissingTemplate
      nil
    end
  end
end