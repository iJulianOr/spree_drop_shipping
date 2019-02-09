require 'spec_helper'

describe BackendImportation, type: :model do
  context 'leftover specs from models' do
    before do
      @file = fixture_file_upload('files/dummy_empty_file.csv', 'text/csv')
      @gfile = fixture_file_upload('files/dummy_file.csv', 'text/csv')
      @s_importation = BackendImportation.new
    end

    let!(:product) { create :product, sku: 'test' }
    let!(:product2) { create :product, sku: 'test2' }
    let!(:zone) { create :zone, name: 'Argentina' }
    let!(:shipping_category) { 2.times { |x| Spree::ShippingCategory.create(name: x) } }
    let(:supplier) { Spree::Supplier.create(name: 'test') }
    let(:importation) { Spree::SupplierImportation.create(status: 'pending', supplier: supplier) }

    it 'should raise failure on use_thread' do
      importation = Spree::SupplierImportation.create(status: 'pending')
      @s_importation.no_thread(nil, importation, nil)
      expect(importation.status).to eq('failed')
    end

    it 'should succed on update with thread' do
      @s_importation.import(@gfile, importation, supplier, { no_thread: true })
      product.reload
      expect(product.total_on_hand).to eq(1)
    end
  end
end
