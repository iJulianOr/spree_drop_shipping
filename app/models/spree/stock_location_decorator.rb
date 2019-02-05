Spree::StockLocation.class_eval do
  belongs_to :entity, polymorphic: true
end
