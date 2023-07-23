FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password' }

    trait :student do
      after(:create) { |user| user.add_role(:student) }
    end

    trait :school_admin do
      after(:create) { |user| user.add_role(:school_admin) }
    end

    trait :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
