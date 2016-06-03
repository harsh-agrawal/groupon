class LocationValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:base, "Deal must have atleast one location.") if record.locations.blank?
  end
end