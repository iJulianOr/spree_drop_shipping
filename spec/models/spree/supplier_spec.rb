require 'spec_helper'
require 'byebug'

RSpec.describe Spree::Supplier, type: :model do
  before do
    Spree::Zone.create!(name: 'Argentina')
    2.times do |x|
      Spree::ShippingCategory.create!(name: x)
    end
  end

  it 'should be valid' do
    expect(Spree::Supplier.new).to be_valid
  end

  it 'should be created properly' do
    expect { Spree::Supplier.create(name: 'Test') }.not_to raise_error
  end

  it 'should require name' do
    expect { Spree::Supplier.create! }.to raise_error(ActiveRecord::RecordNotSaved)
  end

  it 'should rise error if repeated name' do
    expect { 2.times { Spree::Supplier.create!(name: 'Test') } }.to raise_error(ActiveRecord::RecordInvalid)
  end

  context 'create associations' do
    let!(:supplier) { Spree::Supplier.create(name: 'Test', shipping_methods: [create(:shipping_method)]) }
    let!(:product) { create(:product_in_stock, name: 'Product 1 test', catalogues: [supplier.catalogue]) }
    let!(:order) { create(:order, entity: supplier) }

    it 'should be created with catalogue' do
      expect(supplier.catalogue).not_to eq(nil)
    end

    it 'should be created with stock location' do
      expect(supplier.stock_location).not_to eq(nil)
    end

    it 'should be created with shipping method' do
      expect(supplier.shipping_methods.any?).to eq(true)
    end

    it 'should have importations' do
      expect(supplier.importations.new).to be_valid
    end

    context ': orders' do
      it 'should assign order' do
        expect(supplier.orders).not_to be_empty
      end

      it 'should respond to entity' do
        expect(order.entity?).to eq(true)
      end

      context 'hacky workaround to orders' do
        before(:each) do
          supplier.shipping_methods.push create(:shipping_method)
          order.user = create :user
          order.next
          order.shipments.create
          Spree::ShippingRate.create shipment_id: order.shipments.first.id, shipping_method_id: supplier.shipping_methods.first.id
        end

        it 'should return rates' do
          expect(order.shipments.first.shipping_rates).not_to be_empty
        end

        it 'should return states' do
          expect(order.shipments.states).not_to be_empty
        end
      end
    end

    context ': product' do
      it 'should assign products' do
        expect(supplier.products).not_to be_empty
      end

      it 'should not be drop shippeable' do
        expect(product.drop_shippeable?).to eq(false)
      end

      it 'should be drop shippeable if have stock' do
        product.stock_items.find_by(stock_location_id: supplier.stock_location.id).set_count_on_hand(1)
        expect(product.drop_shippeable?).to eq(true)
      end

      it 'should let assign new supplier' do
        supplier2 = Spree::Supplier.create(name: 'Test 2')
        product.supplier = supplier2
        expect(supplier2.products).to include(product)
      end
    end
  end

  context 'destroy associations' do
    let!(:supplier) { Spree::Supplier.create(name: 'Test') }

    it 'should destroy catalogue' do
      catalogue_id = supplier.catalogue.id
      supplier.destroy
      expect { Spree::Catalogue.find(catalogue_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should destroy stock location' do
      stock_location_id = supplier.stock_location.id
      supplier.destroy
      expect { Spree::StockLocation.find(stock_location_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should destroy importations' do
      2.times { supplier.importations.create! }
      importation_ids = supplier.importations.pluck :id
      supplier.destroy
      expect(Spree::SupplierImportation.where(id: importation_ids).any?).to eq(false)
    end

    it 'should destroy shipping methods' do
      shipping_method_ids = supplier.shipping_methods.pluck :id
      supplier.destroy
      expect(Spree::ShippingMethod.where(id: shipping_method_ids).any?).to eq(false)
    end
  end
end
