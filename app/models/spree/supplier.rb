module Spree
  class Supplier < Spree::Base
    has_one :stock_location, class_name: 'Spree::StockLocation', as: :entity, dependent: :destroy
    has_one :catalogue, class_name: 'Spree::Catalogue', as: :entity, dependent: :destroy
    has_many :orders, class_name: 'Spree::Order', as: :entity
    has_many :products, through: :catalogue
    has_many :shipping_methods, class_name: 'Spree::ShippingMethod', as: :entity, dependent: :destroy

    validates :name, uniqueness: { case_sensitive: false }

    after_create :create_catalogue
    after_create :create_stock_location
    after_create :create_shipping_methods

    private

    def create_catalogue
      self.catalogue = Spree::Catalogue.create
      save!
    end

    def create_stock_location
      self.stock_location = Spree::StockLocation.create(name: name)
      save!
    end
    
    def create_shipping_methods
      create_shipping_method('Andreani')
      # create_shipping_method('CorreoArgentino')
    end
    
    private

    def create_shipping_method(method)
      calculator = "Spree::Calculator::Shipping::#{method}".constantize.create!
      zone = Spree::Zone.find_by(name: 'Argentina')
      self.shipping_methods.create!(name: method, calculator: calculator, zones: [zone], shipping_categories: [Spree::ShippingCategory.second])
      save!
    end
  end
end
