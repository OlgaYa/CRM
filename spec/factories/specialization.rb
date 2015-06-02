# == Schema Information
#
# Table name: specializations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :specialization do
    sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }
  end
end