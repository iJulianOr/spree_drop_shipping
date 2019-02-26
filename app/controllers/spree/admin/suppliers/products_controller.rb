module Spree
  module Admin
    module Suppliers
      class ProductsController < Spree::Admin::BaseController
        before_filter :load_supplier, only: [:index, :update, :destroy]

        def load_supplier
          @supplier = Spree::Supplier.find(params[:id])
          @products = @supplier.products.joins(:translations).order('spree_product_translations.name')
        end

        def index; end

        def destroy
          @supplier.catalogue.products = @products - [@products.find(params[:product_id])]
          flash[:success]              = 'Producto borrado con éxito.'
          redirect_to :back
        end

        def change_stock
          supplier       = Spree::Supplier.find(params[:id])
          stock_location = supplier.stock_location
          products       = params[:stock]
          products.map do |product, stock|
            set_count_on_hand_for(product, stock.to_i, stock_location)
          end
          redirect_to :back, alert: 'Producto cargado con éxito'
        end

        def update
          product_ids = product_params[:product_id].split(',')
          products    = Spree::Product.with_deleted.where(id: product_ids).where.not(id: @supplier.catalogue.products.pluck(:id))
          @supplier.catalogue.products << products
          @supplier.catalogue.save
          redirect_to :back
        end

        private

        def product_params
          params.require(:supplier).permit(:product_id)
        end

        def set_count_on_hand_for(id, stock, location)
          product = Spree::Product.find(id)
          product.stock_items.find_by(stock_location: location).set_count_on_hand(stock)
        end
      end
    end
  end
end
