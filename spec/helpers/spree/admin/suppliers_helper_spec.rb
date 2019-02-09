require 'spec_helper'
require 'byebug'

# Specs in this file have access to a helper object that includes
# the Spree::Admin::SuppliersHelper. For example:
#
# describe Spree::Admin::SuppliersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe Spree::Admin::SuppliersHelper, type: :helper do
  describe 'edit_admin_resource_path' do
    let!(:zone) { create :zone, name: 'Argentina' }
    let!(:shipping_category) { 2.times { |x| Spree::ShippingCategory.create(name: x) } }
    let!(:supplier) { Spree::Supplier.create(name: 'Test') }

    it 'should return supplier path' do
      expect(admin_resource_path(supplier)).to eq("/admin/suppliers/#{supplier.id}")
    end
    
    it 'should return supplier edit path' do
      expect(edit_admin_resource_path(supplier)).to eq("/admin/suppliers/#{supplier.id}/edit")
    end
  end
end
