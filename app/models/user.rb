# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  first_name                   :string(255)      not null
#  last_name                    :string(255)      not null
#  email                        :string(255)      not null
#  password_digest              :string(255)      not null
#  admin                        :boolean          default(FALSE)
#  remember_token               :string(255)
#  verification_token           :string(255)
#  verification_token_expire_at :datetime
#  verified_at                  :datetime
#  forgot_password_token        :string(255)
#  forgot_password_expire_at    :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_users_on_email                  (email) UNIQUE
#  index_users_on_forgot_password_token  (forgot_password_token)
#  index_users_on_remember_token         (remember_token)
#  index_users_on_verification_token     (verification_token)
#

class User < ActiveRecord::Base
  has_secure_password

  attr_accessor :password_required

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: REGEXP[:email],
                                                                                     message: "Invalid Format"}
  validates :password, length: { minimum: 6 }, if: "password_required.present?"

  scope :verified, -> { where.not(verified_at: nil) }

  has_many :orders, dependent: :restrict_with_error
  has_many :payment_transactions, dependent: :restrict_with_error

  before_validation :set_password_required, on: :create
  before_create :set_and_generate_verification_token, if: '!admin'
  after_commit :send_verification_mail, on: :create, if: '!admin'

  def valid_verification_token?
    Time.current <= verification_token_expire_at
  end

  def valid_forgot_password_token?
    Time.current <= forgot_password_expire_at
  end

  def change_password(password, confirm_password)
    self.password = password
    self.password_confirmation = confirm_password
    set_password_required
    self.forgot_password_token = nil
    self.forgot_password_expire_at = nil
    save
  end

  def verify!
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expire_at = nil
    save!
  end

  def set_forgot_password_token!
    generate_token(:forgot_password_token)
    set_token_expiry(:forgot_password_expire_at)
    save!
    UserNotifier.password_reset_mail(self).deliver_now
  end

  def set_remember_token
    generate_token(:remember_token)
    save!
  end

  def clear_remember_token!
    self.remember_token = nil
    save!
  end

  def qty_can_be_purchased(deal)
    deal.max_qty_per_customer - orders.by_deal(deal.id).placed.sum(:quantity)
  end

  private

  def set_password_required
    self.password_required = true
  end

  def random_token
    SecureRandom.urlsafe_base64.to_s
  end

  def set_and_generate_verification_token
    generate_token(:verification_token)
    set_token_expiry(:verification_token_expire_at)
  end

  def set_token_expiry(column)
    self[column] = CONSTANTS["time_to_verify"].hours.from_now
  end

  def send_verification_mail
    UserNotifier.verification_mail(self).deliver_now
  end

  def generate_token(token_for)
    loop do
      token_value = random_token
      if !(User.exists?(token_for => token_value))
        self[token_for] = token_value
        break
      end
    end
  end

end
