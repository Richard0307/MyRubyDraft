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
class Notification < ApplicationRecord
end
