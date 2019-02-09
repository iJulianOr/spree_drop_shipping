require 'spec_helper'
require 'byebug'

RSpec.describe Spree::StockItem, type: :model do
  before do
    Spree::Zone.create!(name: 'Argentina')
    2.times do |x|
      Spree::ShippingCategory.create!(name: x)
    end
  end

  let(:product) { create :product }
  context 'when no supplier is assigned' do
    it 'should return nil on check_supplier' do
      expect(product.stock_items.first.check_supplier).to eq(nil)
    end
  end

  context 'when no supplier is assigned' do
    let(:product3) { create :product }
    it 'should return true on check supplier' do
      supplier = Spree::Supplier.create name: 'test'
      supplier.catalogue.products.push product3
      product3.stock_items.reload
      supplier.catalogue.products.clear
      product3.reload
      expect(product3.drop_shippeable?).to eq(false)
      product3.stock_items.find_by(stock_location_id: supplier.stock_location.id).set_count_on_hand 10
      product3.reload
      expect(product3.drop_shippeable?).to eq(true)
    end
  end
end
