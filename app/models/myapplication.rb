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
class Myapplication < ApplicationRecord
  validates_presence_of :company, :role, :application_deadline, :status, :date_applied, :location
  attr_accessor :job_description
  attr_accessor :notes_for_interview_and_reflections
end
