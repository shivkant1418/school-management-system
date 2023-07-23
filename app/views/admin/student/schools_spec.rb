require 'rails_helper'

RSpec.feature 'Student Schools', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:school) { FactoryBot.create(:school) }

  background do
    login_as(student)
  end

  scenario 'Student can access the schools index page' do
    visit schools_path
    expect(page).to have_content(school.name)
  end
end
