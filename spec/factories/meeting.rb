# == Schema Information
#
# Table name: meetings
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  location    :string
#  start_time  :datetime
#  end_time    :datetime
#  table_id    :integer
#  event_id    :string
#  for_type    :string
#  email       :string
#

FactoryGirl.define do
  factory :meeting do
    title       { Faker::Lorem.word                                       }
    description { Faker::Lorem.sentence                                   }
    location    { Faker::Lorem.sentence                                   }
    start_time  { Faker::Time.between(DateTime.now, DateTime.now + 1)     }
    end_time    { Faker::Time.between(DateTime.now + 2, DateTime.now + 3) }
    email       { Faker::Internet.email                                   }
    table
    trait :sale do
      for_type 'sale'
    end
    trait :candidate do
      for_type 'candidate'
    end
  end
end