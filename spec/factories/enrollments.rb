FactoryBot.define do
  factory :enrollment do
    association :batch
    student { FactoryBot.create(:user, :student) }
    status { :pending }

    trait :approved do
      status { :approved }
    end

    trait :rejected do
      status { :rejected }
    end
  end
end
