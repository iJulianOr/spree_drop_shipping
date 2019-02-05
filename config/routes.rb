Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :suppliers, controller: 'suppliers'
    get '/suppliers/:id/products', to: 'suppliers/products#index', as: 'supplier_products'
    post '/suppliers/:id/products', to: 'suppliers/products#update', as: 'update_supplier_products'
    post '/suppliers/change_stock', to: 'suppliers/products#change_stock', as: 'change_supplier_stock'
  end
end
