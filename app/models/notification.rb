# == Schema Information
#
# Table name: notifications
#
#  id          :bigint           not null, primary key
#  date        :date
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user

  def read?
    read_attribute(:read_at).present?
  end
  validates :title, presence: true
  validates :description, presence: true
  validates :date, presence: true
  scope :unread, -> { where(read: false) }
end

