FactoryBot.define do
  factory :school do
    name { Faker::University.unique.name }
    address { Faker::Address.city }
    description { Faker::Lorem.sentences.join(' ') }
  end
end
