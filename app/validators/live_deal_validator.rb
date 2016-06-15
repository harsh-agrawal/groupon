class LiveDealValidator < ActiveModel::Validator
  def validate(record)
    if( record.deal.expired? )
      record.errors.add(:base, 'Orders cannot be placed on past deals')
    end
  end
end