# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  admin                  :boolean          default(FALSE)
#  status                 :string           default("unlock")
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  table_settings         :string
#

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.email }
    password   'asdfasdf'
    password_confirmation 'asdfasdf'

    trait :admin do
      admin true
    end
    trait :hh do
      role 'hh'
    end
    trait :seller do
      role 'seller'
    end
    trait :hr do
      role 'hr'
    end
    trait :locked do
      status 'lock'
    end
  end
end