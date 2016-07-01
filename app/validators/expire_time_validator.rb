class ExpireTimeValidator < ActiveModel::Validator
  def validate(record)
    if( record.expire_time.present? && record.start_time.present? && record.expire_time < record.start_time )
      record.errors.add(:expire_time, 'should not be less than start time')
    end
  end
end