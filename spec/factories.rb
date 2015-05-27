FactoryGirl.define do

  factory :holiday do
    title Faker::Name.name
    date  DateTime.current
  end

  factory :user do
    first_name  Faker::Name.first_name 
    last_name   Faker::Name.last_name 
    email       Faker::Internet.email
    role       'seller'
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

  
  factory :table do
    trait :candidate do
      type 'Candidate'
      specialization
      level
    end

    trait :sale do
      type 'Sale'
    end
    status
    user
    source
    topic Faker::Lorem.sentence
    name  Faker::Name.name
    email Faker::Internet.email
    skype Faker::Lorem.word
    date  DateTime.current
    phone Faker::PhoneNumber.cell_phone
  end

  factory :link do
    alt  Faker::Lorem.word
    href Faker::Internet.url
    table
  end

  factory :status do
    sequence(:name) { Faker::Lorem.word }

    trait :candidate do
      for_type 'candidate'
    end
    
    trait :sale do
      for_type 'sale'
    end
  end

  factory :source do
    sequence(:name) { Faker::Lorem.word }

    trait :candidate do
      for_type 'candidate'
    end

    trait :sale do
      for_type 'sale'
    end
  end

  factory :level do
    name Faker::Lorem.word
  end

  factory :specialization do
    name Faker::Lorem.word
  end
end
