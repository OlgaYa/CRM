# == Schema Information
#
# Table name: dt_reports
#
#  id         :integer          not null, primary key
#  date       :date
#  time       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :dt_report do
  end
end