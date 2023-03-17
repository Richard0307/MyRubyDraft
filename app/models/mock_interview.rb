# == Schema Information
#
# Table name: mock_interviews
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MockInterview < ApplicationRecord
    belongs_to :user
    attribute :user_id, :integer
    attribute :interviewer_name, :string
end
