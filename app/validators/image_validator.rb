class ImageValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:base, "Deal must have atleast one image.") if record.deal_images.blank?
  end
end