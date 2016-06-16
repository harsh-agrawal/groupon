class QuantityValidator < ActiveModel::Validator
  def validate(record)
    if record.deal.quantity_available > 0
      qty_can_be_purchased = record.user.qty_can_be_purchased(record.deal)
      qty_allowed = qty_can_be_purchased - record.quantity
      if qty_allowed < 0
        record.errors.add(:base, "Max. limit exceede. Deals per customer allowed is only #{ record.deal.max_qty_per_customer }.")
      end
    else
      record.errors.add(:base, "Deal has been sold out")
    end
  end
end