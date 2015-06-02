# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  for_type   :string           default("sale")
#

FactoryGirl.define do
  factory :source do
    sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }

    trait :candidate do
      for_type 'candidate'
    end
    trait :sale do
      for_type 'sale'
    end
  end
end