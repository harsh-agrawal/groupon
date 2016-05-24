class User < ActiveRecord::Base
  #FIXME_AB: read about this
  has_secure_password
  
  validates :name, presence: true, length: { maximum: 50 }
  #FIXME_AB: uniqueness is case sensitive. akhil@vinsol.com Akhil@VINSOL.com should be same. check uniqueness options
  validates :email, presence: true, uniqueness: true, format: { with: REGEXP[:email], 
    message: "Invalid Format"}
  validates :password, length: { minimum: 6 }
  

  before_create :generate_verification_token

  private

    def random_token
      SecureRandom.urlsafe_base64.to_s
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

    #FIXME_AB: This is a private method, you can not call from controller
    def verify!
      self.verified_at = Time.current
      self.verification_token = nil
      save!(:validate => false)
    end
end
