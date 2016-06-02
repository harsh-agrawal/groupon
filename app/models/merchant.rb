# == Schema Information
#
# Table name: merchants
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_merchants_on_email  (email) UNIQUE
#

class Merchant < ActiveRecord::Base
  has_secure_password
  #FIXME_AB: validations missing
  #FIXME_AB: handle deletion
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :deals, dependent: :restrict_with_error
end 
