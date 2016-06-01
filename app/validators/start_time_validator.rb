class StartTimeValidator < ActiveModel::Validator
  def validate(record)
    if( record.start_time.present? && record.start_time < Time.current )
      record.errors.add(:start_time, 'should not be less than current time')
    end
  end
end