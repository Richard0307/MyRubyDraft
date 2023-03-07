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
class Product < ApplicationRecord
  belongs_to :category

  validates :name, :description, :cost, presence: true
  validates :cost, numericality: { greater_than: 0 }
end
