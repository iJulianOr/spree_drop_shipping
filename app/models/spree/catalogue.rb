module Spree
  class Catalogue < Spree::Base
    belongs_to :entity, polymorphic: true
    has_and_belongs_to_many :products, class_name: 'Spree::Product'
    has_many :stock_items, through: :products

    validates_presence_of :entity
  end
end
