require 'spec_helper'

describe Spree::Admin::Suppliers::ImportationsController, type: :controller do
  before do
    RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
    Spree::Supplier.all.map(&:destroy)
  end

  let(:user) { create :admin_user }
  let!(:zone) { create :zone, name: 'Argentina' }
  let!(:shipping_category) { 2.times { |x| Spree::ShippingCategory.create(name: x) } }
  let!(:supplier) { Spree::Supplier.create(name: 'Test') }
  let!(:product) { create :product, sku: 'test' }

  before(:each) do
    login_as(user)
    request.env["HTTP_REFERER"] = '/admin/suppliers'
  end
  
  context 'GET' do
    it 'should be able to get index' do
      spree_get :index, id: supplier.id
      expect(response).to be_success
    end

    it 'should be able to get file' do
      supplier.catalogue.products.push product
      supplier.catalogue.reload
      spree_get :index, id: supplier.id, format: :csv
      expect(response).to be_success
    end
  end

  context 'POST' do
    before do
      supplier.catalogue.products.push product
      supplier.catalogue.reload
      @file = fixture_file_upload('../../files/dummy_file.csv', 'text/csv')
    end

    it 'should upload file' do
      spree_post :new, id: supplier.id, file: @file
      expect(flash[:success]).to be_present
    end

    it 'should raise error on nil file' do
      spree_post :new, id: supplier.id
      expect(flash[:error]).to be_present
    end

    it 'should raise error on random file' do
      spree_post :new, id: supplier.id, file: 'ads'
      expect(flash[:error]).to be_present
    end

    it 'should raise error on empty file' do
      spree_post :new, id: supplier.id, file: ''
      expect(flash[:error]).to be_present
    end
  end
end

def login_as(user = double('user'))
  allow(request.env['warden']).to receive(:authenticate!).and_return(user)
  allow(controller).to receive(:current_spree_user).and_return(user)
end
