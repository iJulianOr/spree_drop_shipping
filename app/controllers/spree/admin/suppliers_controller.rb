module Spree
  module Admin
    class SuppliersController < Spree::Admin::BaseController
      before_filter :load_supplier, only: [:edit, :update, :destroy]
      before_filter :load_collection, only: :index

      def destroy
        @supplier.destroy
        redirect_to :back
      end

      def update
        if @supplier.update_attributes supplier_params
          update_andreani
          success_path
        else
          fail_path
        end
      end

      def show
        redirect_to edit_admin_supplier_path
      end

      def new
        @supplier = Spree::Supplier.new
        @andreani = @supplier.shipping_methods.find_by(name: 'Andreani').try(:calculator)
      end

      def create
        @supplier = Spree::Supplier.new(supplier_params)
        if @supplier.save
          flash[:success] = "¡Éxito! Proveedor #{@supplier.name} creado con éxito."
          redirect_to edit_admin_supplier_path(@supplier)
        else
          flash[:error] = @supplier.errors.full_messages.join(', ')
          redirect_to :back
        end
      end

      private

      def load_collection
        @collection = Spree::Supplier.all
        @collection = @collection.page(params[:page])
                   .per(params[:per_page] || 20)
      end

      def load_supplier
        @supplier = Spree::Supplier.find(params[:id])
        @andreani = @supplier.shipping_methods.find_by(name: 'Andreani').try(:calculator)
      end

      def success_path
        respond_with(@supplier) do |format|
          format.html do
            flash[:success] = flash_message_for(@supplier, :successfully_updated)
            redirect_to edit_admin_supplier_path(@supplier)
          end
          format.js { render layout: false }
        end
      end

      def fail_path
        respond_with(@supplier) do |format|
          format.html do
            flash.now[:error] = @supplier.errors.full_messages.join(', ')
            render edit_admin_supplier_path(@supplier)
          end
          format.js { render layout: false }
        end
      end

      def update_andreani
        @andreani.preferences.merge! andreani_params
        @andreani.save
      end
      
      def update_correo
        @correo.preferences.merge! correo_params
        @correo.save
      end

      def supplier_params
        params.require(:supplier).permit(:name, :email)
      end

      def andreani_params
        params.require(:supplier)[:andreani].symbolize_keys
      end
      
      def correo_params
        params.require(:supplier)[:correo].symbolize_keys
      end
    end
  end
end
