require 'rails_helper'

RSpec.feature 'Student Courses', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:course) { FactoryBot.create(:course) }

  background do
    login_as(student)
    student.courses << course
  end

  scenario 'Student can access the courses index page' do
    visit courses_path
    expect(page).to have_content(course.title)
  end
end
