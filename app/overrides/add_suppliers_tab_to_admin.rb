Deface::Override.new(virtual_path: 'spree/layouts/admin',
                     name: 'create_suppliers_tab',
                     insert_top: '[data-hook="admin_tabs"]',
                     partial: 'spree/admin/shared/suppliers'
                    )
