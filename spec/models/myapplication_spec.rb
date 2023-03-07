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
require 'rails_helper'

RSpec.describe Myapplication, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
