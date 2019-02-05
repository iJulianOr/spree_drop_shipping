module Spree::Admin::Suppliers::ProductsHelper
  def edit_admin_resource_path(resource)
    resource_name = resource.class.name.demodulize.downcase
    resource_id   = resource.respond_to?(:friendly_id) ? resource.friendly_id : resource.id
    Spree::Core::Engine.routes.url_helpers.send("edit_admin_#{resource_name}_path", resource_id)
  end

  def admin_resource_path(resource)
    resource_name = resource.class.name.demodulize.downcase
    resource_id   = resource.respond_to?(:friendly_id) ? resource.friendly_id : resource.id
    Spree::Core::Engine.routes.url_helpers.send("admin_#{resource_name}_path", resource_id)
  end
end
