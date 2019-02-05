module Spree
  Product.class_eval do
    has_and_belongs_to_many :catalogues, class_name: 'Spree::Catalogue'
    # We may want to have plenty of entities having products through catalogues
    # for example Retails [in case of multiseller module]
    # so we want to split them according to them source_type
    has_many :suppliers, through: :catalogues, source: :entity, source_type: 'Spree::Supplier'

    # If a product doesn't have a supplier
    # then it cannot be drop shipped.
    # In a future it may have some other conditions
    def drop_shippeable?
      !!supplier && supplier.shipping_methods.any?
    end

    def supplier
      # NOTE this is temporal, i guess we'll
      # never want a product to have many
      # suppliers but is needed to have it
      # ready for those changes in a future
      # if needed
      suppliers.first
    end

    def supplier=(supplier)
      supplier.catalogue.products << self
      supplier.catalogue.save
    end
  end
end
