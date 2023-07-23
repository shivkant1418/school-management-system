FactoryBot.define do
  factory :batch do
    association :course
    name { "Batch - #{SecureRandom.hex(5)}" }
    description { Faker::Lorem.sentences.join(' ') }
    start_date { DateTime.now }
    end_date { start_date + 1.day }
  end
end
