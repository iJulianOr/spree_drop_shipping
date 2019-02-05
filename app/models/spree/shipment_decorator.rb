module Spree
  Shipment.class_eval do
    def shipping_rates
      return super unless order.entity?
      super.where(shipping_method_id: order.entity.shipping_methods.pluck(:id))
    end
  end
end
