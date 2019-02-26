module Spree
  class SupplierTrackingNumberMailer < BaseMailer
    def notify_supplier(pdf, order)
      attachments["#{order.number}.pdf"] = pdf

      mail from:      from_address,
           reply_to:  from_address,
           subject:   'Venta Hogarnet',
           to:        order.supplier.email
    end
  end
end
