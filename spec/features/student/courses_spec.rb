require 'rails_helper'

RSpec.feature 'Courses', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:course) { FactoryBot.create(:course) }

  before :each do
    login(student)

    visit courses_path
  end

  it "student can access the courses index page" do
    expect(page).to have_content(course.name)
  end
end




