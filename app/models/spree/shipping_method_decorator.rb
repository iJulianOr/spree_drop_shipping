module Spree
  ShippingMethod.class_eval do
    belongs_to :entity, polymorphic: true
  end
end
