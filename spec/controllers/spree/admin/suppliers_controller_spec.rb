require 'spec_helper'

describe Spree::Admin::SuppliersController, type: :controller do
  before do
    RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
    Spree::Supplier.all.map(&:destroy)
  end

  let(:user) { create :admin_user }
  let!(:zone) { create :zone, name: 'Argentina' }
  let!(:shipping_category) { 2.times { |x| Spree::ShippingCategory.create(name: x) } }
  let!(:supplier) { Spree::Supplier.create(name: 'Test') }

  before(:each) do
    login_as(user)
    request.env["HTTP_REFERER"] = '/admin/suppliers'
  end

  context 'GET' do
    it 'should be able to get index' do
      spree_get :index
      expect(response).to be_success
    end

    it 'should be able to get edit' do
      spree_get :edit, id: supplier.id
      expect(response).to be_success
    end

    it 'should be able to get new' do
      spree_get :new
      expect(response).to be_success
    end

    it 'show should redirect to edit' do
      spree_get :show, id: supplier.id
      expect(response.status).to eq(302)
    end
  end

  context 'POST' do
    it 'should be able to post create' do
      spree_post :create, supplier: { name: 'test 2' }
      expect(flash[:success]).to be_present
    end

    it 'should be able to fail post create' do
      spree_post :create, supplier: { name: 'test' }
      expect(flash[:error]).to be_present
    end
  end
  
  context 'PUT' do
    let!(:supplier2) { Spree::Supplier.create(name: 'Test 3') }

    it 'should be able to put update' do
      spree_put :update, id: supplier.id, supplier: { id: supplier.id, name: 'test 2', andreani: { username: 'testing' } }
      expect(flash[:success]).to be_present
    end

    it 'should not allow repeated name' do
      spree_put :update, id: supplier.id, supplier: { id: supplier.id, name: 'test 3', andreani: { username: 'testing' } }
      expect(flash[:error]).to be_present
    end
  end

  context 'DELETE' do
    it 'should destroy supplier' do
      spree_delete :destroy, id: supplier.id
      expect { supplier.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

def login_as(user = double('user'))
  allow(request.env['warden']).to receive(:authenticate!).and_return(user)
  allow(controller).to receive(:current_spree_user).and_return(user)
end
