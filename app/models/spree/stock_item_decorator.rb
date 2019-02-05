module Spree
  StockItem.class_eval do
    after_update :check_supplier
    has_one :product, through: :variant

    def check_supplier
      return unless stock_location.entity_type == 'Spree::Supplier' && !product.drop_shippeable?
      product.supplier = stock_location.entity
      product.save
    end
  end
end
