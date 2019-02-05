Deface::Override.new virtual_path:  'spree/admin/products/index',
                     name:          'add_drop_shipping_td_to_products',
                     insert_top:    '[data-hook="admin_products_index_rows"]',
                     text:       '<td class="actions text-center"><%= product.drop_shippeable? ? "Sí" : "No" %></td>'

Deface::Override.new virtual_path:  'spree/admin/products/index',
                     name:          'add_drop_shipping_th_to_products',
                     insert_top:    '[data-hook="admin_products_index_headers"]',
                     text: '<th class="text-center">Venta Verde</th>'
