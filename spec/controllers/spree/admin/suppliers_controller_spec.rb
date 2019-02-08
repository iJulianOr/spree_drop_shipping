require 'spec_helper'

xdescribe Spree::Admin::SuppliersController do

  context 'ABM methods' do
    let(:user) { create(:user) }

    before(:each) do
      login_as(user, scope: :spree_user)
    end

    let!(:zone) { create :zone, name: 'Argentina' }
    let!(:shipping_category) { 2.times { |x| Spree::ShippingCategory.create(name: x) } }
    let!(:supplier) { Spree::Supplier.create(name: 'Test') }

    it 'should destroy' do
      spree_get :index
      response.should be_success
    end
  end
end
