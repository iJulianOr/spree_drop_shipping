Spree::Order.class_eval do
  has_many :shipments, dependent: :destroy, inverse_of: :order, before_add: :validate_shipment do
    def states
      pluck(:state).uniq
    end
  end

  belongs_to :entity, polymorphic: true

  def entity?
    entity_id?
  end

  private

  def validate_shipment(shipment)
    return unless entity?
    shipment.stock_location = entity.stock_location
  end
end
