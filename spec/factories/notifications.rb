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
#
FactoryBot.define do
  factory :notification do
    title { "MyString" }
    description { "MyText" }
    date { "2023-02-26" }
  end
end
