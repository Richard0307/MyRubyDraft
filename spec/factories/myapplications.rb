# == Schema Information
#
# Table name: myapplications
#
#  id                   :bigint           not null, primary key
#  application_deadline :date
#  company              :string
#  date_applied         :date
#  location             :string
#  role                 :string
#  status               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :myapplication do
    name { "MyString" }
    description { "MyText" }
  end
end
