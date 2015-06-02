# == Schema Information
#
# Table name: tables
#
#  id                :integer          not null, primary key
#  type              :string
#  name              :string
#  level_id          :integer
#  specialization_id :integer
#  email             :string
#  source_id         :integer
#  date              :datetime
#  status_id         :integer
#  topic             :string
#  skype             :string
#  user_id           :integer
#  price             :integer
#  date_start        :date
#  date_end          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  reminder_date     :datetime
#  phone             :string
#  date_status_1     :date
#

FactoryGirl.define do
  factory :table do
    status
    user
    source

    topic    { Faker::Lorem.sentence         }
    name     { Faker::Name.name              }
    email    { Faker::Internet.email         }
    skype    { Faker::Lorem.word             }
    date     { DateTime.current              }
    phone    { Faker::PhoneNumber.cell_phone }
    
    trait :candidate do
      type 'Candidate'
      specialization
      level
    end
    trait :sale do
      type 'Sale'
    end
  end
end