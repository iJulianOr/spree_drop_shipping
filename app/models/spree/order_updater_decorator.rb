module Spree
  OrderUpdater.class_eval do
    def update_payment_state
      last_state = order.payment_state
      if payments.present? && payments.valid.size == 0
        order.payment_state = 'failed'
      elsif order.state == 'canceled' && order.payment_total == 0
        order.payment_state = 'void'
      else
        order.payment_state = 'balance_due' if order.outstanding_balance > 0
        order.payment_state = 'credit_owed' if order.outstanding_balance < 0
        order.payment_state = 'paid' if !order.outstanding_balance?
      end
      order.state_changed('payment') if last_state != order.payment_state
      notify_supplier! if order.payment_state == 'paid'
      order.payment_state
    end

    def notify_supplier!
      shipping_method = order.shipments.last.shipping_method
      return unless shipping_method
      return unless shipping_method.calculator_type == 'Spree::Calculator::Shipping::Andreani' && order.entity
      preferences = shipping_method.calculator.preferences
      pdf         = SpreeAndreaniShipment::AndreaniWS.new.link_impresion(numero: order.shipments.last.tracking,
                                                                         username: preferences[:username],
                                                                         password: preferences[:password]) rescue nil
      Spree::SupplierTrackingNumberMailer.notify_supplier(pdf, order).deliver_now
    end
  end
end
