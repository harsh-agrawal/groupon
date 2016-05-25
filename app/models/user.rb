class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: REGEXP[:email],
                                                                                     message: "Invalid Format"}
  validates :password, length: { minimum: 6 }, allow_blank: true


  before_create :set_and_generate_verification_token
  after_commit :send_verification_mail, on: :create

  #FIXME_AB: valid_verification_token?
  def valid_verification_token?
    Time.current <= verification_token_expire_at
  end

  #FIXME_AB: This is verify!
  def verify!
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expire_at = nil
    save!
  end

  private

  def random_token
    SecureRandom.urlsafe_base64.to_s
  end

  def set_and_generate_verification_token
    generate_verification_token
    set_verification_token_expiry
  end

  def set_verification_token_expiry
    self.verification_token_expire_at = (Time.current + CONSTANTS["time_to_verify"].hours)
  end

  def send_verification_mail
    UserNotifier.verification_mail(self).deliver
  end

  def generate_verification_token
    loop do
      verification_token = random_token
      if !(User.exists?(verification_token: verification_token))
        self.verification_token = SecureRandom.urlsafe_base64.to_s
        break
      end
    end
  end

end
