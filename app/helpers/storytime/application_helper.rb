module Storytime
  module ApplicationHelper

    def dashboard_nav_site_path(site)
      site.nil? || site.new_record? ? storytime.new_dashboard_site_path : storytime.edit_dashboard_site_path(site)
    end

    def dashboard_nav_class
      if ["storytime/dashboard/pages", "storytime/dashboard/posts"].include?(params[:controller]) && ["new", "edit", "update", "create"].include?(params[:action])
        "off-canvas-left"
      elsif dashboard_controller
        "off-canvas-left-sm absolute"
      else
        "off-canvas-left"
      end
    end

    def active_nav_item_class(controller, type = nil)
      return if ["storytime/pages", "storytime/posts"].include? params[:controller]
      
      current_controller = params[:controller].split("/").last

      'class="active"'.html_safe if controller == current_controller && ((type.nil? && [nil, 'blog_post'].include?(params[:type])) || type == params[:type])
    end

    def active_admin_model_class(model)
      'active' if params[:controller] == 'storytime/dashboard/admin' && model_name == model
    end

    def delete_resource_link(resource, href = nil, remote = true)
      humanized_resource_name = resource.class.to_s.split('::').last.underscore.humanize.downcase
      resource_name = resource.class.to_s.downcase.split("::").last

      opts = {
        id: "delete_#{resource_name}_#{resource.id}", 
        class: "btn btn-danger btn-outline btn-xs btn-delete-resource delete-#{resource_name}-button", 
        data: { confirm: I18n.t('common.are_you_sure_you_want_to_delete', resource_name: humanized_resource_name), resource_id: resource.id, resource_type: resource_name },
        method: :delete
      }

      if remote
        opts[:remote] = true
      end
      
      link_to content_tag(:i, "", class: "icon-st-icons-trash"), href || resource, opts
    end
    
    def tag_cloud(tags, classes)
      max = tags.sort_by(&:count).last
      tags.each do |tag|
        index = tag.count.to_f / max.count * (classes.size - 1)
        yield(tag, classes[index.round])
      end
    end

    def render_comments
      if Storytime.disqus_forum_shortname.blank?
        render "storytime/comments/comments"
      else
        render "storytime/comments/disqus"
      end
    end

    def method_missing method, *args, &block
      if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      else
        super
      end
    end

    def respond_to?(method)
      if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          true
        else
          super
        end
      else
        super
      end
    end

  end
end
