class QuantityValidator < ActiveModel::Validator
  def validate(record)
    if record.deal.quantity_available > 0
      qty_can_be_purchased = record.user.qty_can_be_purchased(record.deal)
      if qty_can_be_purchased < 0
        record.errors.add(:deals, "limit exceeded. Can now buy only #{ qty_can_be_purchased } deals.")
      elsif qty_can_be_purchased == 0
        record.errors.add(:deals, " limit reached.")
      elsif record.quantity > record.deal.max_qty_per_customer
        record.errors.add(:deals, " per customer allowed is only #{ record.deal.max_qty_per_customer }.")
      end
    else
      record.errors.add(:deals, "Sold Out")
    end
  end
end