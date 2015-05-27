FactoryGirl.define do
  factory :user do
    first_name       { Faker::Name.first_name              }
    last_name        { Faker::Name.last_name               }
    sequence(:email) { |n| "#{Faker::Internet.email}#{n}"  }
    password         { Faker::Internet.password(8, 20)     }

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

  factory :link do
    alt      { Faker::Lorem.word   }
    href     { Faker::Internet.url }
    table
  end

  factory :comment do
    body     { Faker::Lorem.sentence }
    datetime { DateTime.current      }
    user
  end

  factory :table_comment do
    comment
    table
  end

  factory :status do
    sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }

    trait :candidate do
      for_type 'candidate'
    end
    trait :sale do
      for_type 'sale'
    end
  end

  factory :source do
    sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }

    trait :candidate do
      for_type 'candidate'
    end
    trait :sale do
      for_type 'sale'
    end
  end

  factory :level do
    sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }
  end

  factory :specialization do
    sequence(:name) { |n| "#{Faker::Lorem.word}#{n}" }
  end
end