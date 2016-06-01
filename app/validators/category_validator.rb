class CategoryValidator < ActiveModel::Validator
  def validate(record)
    if( record.category_id.present? && !Category.exists?(record.category_id) )
      record.errors.add(:category_id, 'does not exist')
    end
  end
end