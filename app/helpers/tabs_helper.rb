# This module is borrowed from https://github.com/CodeOfficer/jquery-ui-rails-helpers
# Changed to Rails 3 with the help of http://dougselph.com/rails/2010/06/rails3_tabsrenderer/
# And add some modification.
# TODO: write specs!!!
module TabsHelper

  def tabs_for(*options, &block)
    raise ArgumentError, "Missing block" unless block_given?

    tabs = TabsHelper::TabsRenderer.new( *options, &block )
    tabs.render.html_safe
  end

  class TabsRenderer
    def initialize(options={}, &block)
      raise ArgumentError, "Missing block" unless block_given?

      @template = eval('self', block.binding)
      @options = options
      @tabs = []
      @routes = Rails.application.routes

      yield self
    end

    def create(tab_id, tab_text, options={}, &block)
      # raise "Block needed for TabsRenderer#CREATE" unless block_given?
      @tabs << [tab_id, tab_text, options, block]
    end

    def render
      render_tabs.html_safe + render_bodies.html_safe
    end

    private #  ---------------------------------------------------------------------------

    def render_tabs
      content_tag(:ul, render_headers.html_safe, @options)
    end

    def render_headers
      @tabs.collect do |tab|
        content_tag(:li, link_to(content_tag(:span, tab[1]), url(tab[0])), tab[2].delete(:item_html))
      end.join.to_s
    end

    def render_bodies
      @tabs.collect do |tab|
        content = tab[3] ? capture(&tab[3]) : nil
        if content
          content_tag(:div, content, tab[2].merge(:id => tab[0]))
        end
      end.join.to_s
    end

    def method_missing(*args, &block)
      @template.send(*args, &block)
    end

    def url(id_or_url)
      @routes.recognize_path id_or_url
      id_or_url
    rescue ActionController::RoutingError
      "##{id_or_url}"
    end
  end
end
