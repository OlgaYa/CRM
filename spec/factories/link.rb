# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  alt        :string
#  href       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  table_id   :integer
#

FactoryGirl.define do
  factory :link do
    alt      { Faker::Lorem.word   }
    href     { Faker::Internet.url }
    table
  end
end