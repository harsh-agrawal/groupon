class DealImage < ActiveRecord::Base
  validates :name, presence: true
end
