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
#  index_coupons_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_68a5ba75f4  (order_id => orders.id)
#

class Coupon < ActiveRecord::Base
  #FIXME_AB: we'll search coupons based on code so index it unique index
  belongs_to :order

  before_create :generate_token

  #FIXME_AB: validations?

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
end
