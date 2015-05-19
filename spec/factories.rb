FactoryGirl.define do
  factory :user do
    first_name 'John'
    last_name 'Doe'
    admin false
    password 'asdfasdf'
    password_confirmation 'asdfasdf'
    email 'testUser@mail.ru'
    role 'seller'
  end
end
