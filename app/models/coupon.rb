# == Schema Information
#
# Table name: coupons
#
#  id          :integer          not null, primary key
#  order_id    :integer
#  code        :string(255)
#  redeemed_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_coupons_on_code      (code) UNIQUE
#  index_coupons_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_68a5ba75f4  (order_id => orders.id)
#

class Coupon < ActiveRecord::Base
  belongs_to :order

  before_create :generate_token
  #FIXME_AB: uniqueness case?
  before_save :can_be_redeem?
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :order, presence: true

  scope :redeemed, -> { where.not(redeemed_at: nil) }

  def random_token
    SecureRandom.hex(5)
  end

  def generate_token
    loop do
      token_value = random_token
      if !(Coupon.exists?(code: token_value))
        self.code = token_value
        break
      end
    end
  end

  #FIXME_AB: redeem
  def redeem
    #FIXME_AB: you should check if coupon can be redeem by before_save
    self.redeemed_at = Time.current
    save
  end

  private

  def can_be_redeem?
    redeemed_at_was == nil && redeemed_at != nil
  end


end
