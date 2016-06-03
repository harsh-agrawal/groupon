# == Schema Information
#
# Table name: deal_images
#
#  id                 :integer          not null, primary key
#  deal_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#
# Indexes
#
#  index_deal_images_on_deal_id  (deal_id)
#
# Foreign Keys
#
#  fk_rails_b960765e85  (deal_id => deals.id)
#

class DealImage < ActiveRecord::Base
  #FIXME_AB: when uploading image generate a thumbnail of 150px 150px, which we can use in the edit form and other place
  has_attached_file :image, styles: { thumb: "150x150>" }
  validates_attachment :image, presence: true, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  belongs_to :deal
end
