# == Schema Information
#
# Table name: mock_interviews
#
#  id               :bigint           not null, primary key
#  feedback         :text
#  interviewer_name :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_mock_interviews_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MockInterview < ApplicationRecord
  after_save :create_notification

  belongs_to :user

  private

  def create_notification
    return unless user.is_student? # 只有学生需要收到通知

    notification = Notification.new(
      title: "New mock interview feedback received",
      description: "You have received new feedback for your mock interview with #{interviewer_name}.",
      date: Date.today
    )

    user.notifications << notification
  end
end
