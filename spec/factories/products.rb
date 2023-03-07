# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  cost        :decimal(, )
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#
FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyText" }
    cost { "9.99" }
  end
end
