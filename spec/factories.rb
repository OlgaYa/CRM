FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name  Faker::Name.last_name
    admin      false
    email      Faker::Internet.email
    role       'seller'
    password   'asdfasdf'
    password_confirmation 'asdfasdf'
  end
end


