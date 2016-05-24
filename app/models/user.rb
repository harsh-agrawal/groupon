class User < ActiveRecord::Base
  has_secure_password
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: REGEXP[:email], 
    message: "Invalid Format"}
  validates :password, length: { minimum: 6 }
  

  before_create :set_and_generate_verification_token
  after_commit :send_verification_mail, on: :create

  def verify!
    self.verified_at = Time.current
    self.verification_token = nil
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
      # move TTV to constants.yml
      self.verification_token_expire_at = Time.current + 6.hours
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
