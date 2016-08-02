# == Schema Information
#
# Table name: notification_tokens
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notification_tokens_on_user_id  (user_id)
#

class NotificationToken < ActiveRecord::Base
  belongs_to :user

  validates :token, presence: true
end
