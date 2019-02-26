require 'spec_helper'

RSpec.describe Spree::Catalogue, type: :model do
  context 'create' do
    let!(:zone) { create :zone, name: 'Argentina' }
    let!(:shipping_category) { 2.times { |x| Spree::ShippingCategory.create(name: x) } }
    let!(:supplier) { Spree::Supplier.create(name: 'Test') }
    let!(:product) { create :product }
    let!(:catalogue) { Spree::Catalogue.create!(entity: supplier, products: [product]) }

    it 'should require a supplier' do
      expect { Spree::Catalogue.create! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    context 'with products' do
      it 'should assing products' do
        catalogue = Spree::Catalogue.create!(entity: supplier)
        expect(catalogue.products).to be_empty
        catalogue.products << product
        expect(catalogue.products).not_to be_empty
      end

      it 'should not be drop shippeable' do
        expect(product.drop_shippeable?).to eq(false)
      end

      it 'should be drop shippeable if have stock' do
        product.stock_items.find_by(stock_location_id: catalogue.entity.stock_location.id).set_count_on_hand(3)
        expect(product.drop_shippeable?).to eq(true)
      end

      it 'should match suppliers' do
        expect(product.supplier).to eq(supplier)
      end
    end
  end
end
