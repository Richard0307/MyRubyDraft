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
FactoryBot.define do
  factory :mock_interview do
    interviewer_name { "MyString" }
    feedback { "MyText" }
    user { nil }
  end
end
