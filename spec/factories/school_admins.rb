FactoryBot.define do
  factory :school_admin, class: 'School::Admin' do
    association :school, factory: :school
    user { FactoryBot.create(:user, :school_admin) }
  end
end
