# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  address    :string(255)      not null
#  city       :string(255)      not null
#  state      :string(255)      not null
#  country    :string(255)      not null
#  deal_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_deal_id  (deal_id)
#
# Foreign Keys
#
#  fk_rails_c14235c781  (deal_id => deals.id)
#
class Location < ActiveRecord::Base
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  belongs_to :deal
end
