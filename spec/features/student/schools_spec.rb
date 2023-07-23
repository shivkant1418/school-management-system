require 'rails_helper'

RSpec.feature 'Schools', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:school) { FactoryBot.create(:school) }

  before :each do
    login(student)

    visit schools_path
  end

  it "student can access the schools index page" do
    expect(page).to have_content(school.name)
  end
end

