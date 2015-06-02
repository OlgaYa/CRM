# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  date_from  :date
#  date_to    :date
#  for_type   :string           default("sale")
#  count      :integer          default(0)
#  percentage :integer          default(0)
#

FactoryGirl.define do
  factory :plan do
    date_from       { Faker::Date.between(2.days.ago, Date.today) }
    date_to         { Faker::Date.forward(23)                     }
    count           { Faker::Number.digit                         }
    trait :sale do
      for_type 'sale'
    end
    trait :candidate do
      for_type 'candidate'
    end
  end
end
