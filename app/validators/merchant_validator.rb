class MerchantValidator < ActiveModel::Validator
  def validate(record)
    if( record.merchant_id.present? && !Merchant.exists?(record.merchant_id) )
      record.errors.add(:merchant_id, 'does not exist')
    end
  end
end