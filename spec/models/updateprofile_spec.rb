# == Schema Information
#
# Table name: updateprofiles
#
#  id                     :bigint           not null, primary key
#  course                 :string
#  email                  :string
#  first_name             :string
#  last_name              :string
#  location               :string
#  reason_for_withdrawing :string
#  sector                 :string
#  student_status         :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

RSpec.describe Updateprofile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
