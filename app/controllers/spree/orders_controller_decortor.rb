Spree::OrdersController.class_eval do
  after_action :assign_entity, only: :populate

  def assign_entity
    @order.entity = @order.products.first.supplier
    @order.save
  end
end
