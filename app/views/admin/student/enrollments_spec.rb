require 'rails_helper'

RSpec.feature 'Student Enrollments', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:course) { FactoryBot.create(:course) }
  let!(:batch) { FactoryBot.create(:batch, course: course) }

  background do
    login_as(student)
    student.courses << course
    FactoryBot.create(:enrollment, student: student, batch: batch)
  end

  scenario 'Student can access the enrollments index page' do
    visit student_enrollments_path
    expect(page).to have_content(batch.name)
  end
end
