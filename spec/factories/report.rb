# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  project    :string
#  task       :string
#  user_id    :integer
#  hours      :float
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :report do
    user
    project { Faker::Lorem.sentence }
    task    { Faker::Lorem.sentence }
    date    { DateTime.current      }
    hours   5
  end
end