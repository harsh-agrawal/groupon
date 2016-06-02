# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#

class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :deals, dependent: :restrict_with_error
end
