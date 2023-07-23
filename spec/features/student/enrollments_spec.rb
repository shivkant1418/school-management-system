require 'rails_helper'

RSpec.feature 'Student Enrollments', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:course) { FactoryBot.create(:course) }
  let!(:batch) { FactoryBot.create(:batch, course: course) }
  let!(:enrollment) { FactoryBot.create(:enrollment, student: student, batch: batch) }

  context "when is logged out" do
    it "redirects student to the sign in page" do
      visit student_enrollments_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "when is logged in" do
    before :each do
      login(student)

      visit student_enrollments_path
    end

    it "student can access the enrollment index page" do
      expect(page).to have_content(batch.name)
    end
  end
end


