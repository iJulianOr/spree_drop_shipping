module Spree
  class SupplierTrackingNumberMailer < BaseMailer
    def notify_supplier(pdf, order)
      attachments["#{order.number}.pdf"] = pdf
      @order                             = order

      mail from:      from_address,
           reply_to:  from_address,
           subject:   'Venta Hogarnet',
           to:        order.entity.email
    end
  end
end
