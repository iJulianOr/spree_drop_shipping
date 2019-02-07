module Spree
  class SupplierImportation < Spree::Base
    has_many :products, class_name: 'Spree::Product'
    belongs_to :supplier, class_name: 'Spree::Supplier'
  end
end
