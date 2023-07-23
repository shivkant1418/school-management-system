FactoryBot.define do
  factory :course do
    association :school
    name { Faker::Educator.unique.course_name }
    description { Faker::Lorem.sentences.join(' ') }
  end
end
