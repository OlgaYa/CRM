# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :permission do
    name        { Faker::Lorem.word     }
    description { Faker::Lorem.sentence }
  end
end