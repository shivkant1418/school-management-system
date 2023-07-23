require 'rails_helper'

RSpec.feature 'Student Enrollments', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:course) { FactoryBot.create(:course) }
  let!(:course_2) { FactoryBot.create(:course) }
  let!(:batch) { FactoryBot.create(:batch, course: course) }
  let!(:enrollment) { FactoryBot.create(:enrollment, student: student, batch: batch) }

  context "when is logged out" do
    it "redirects student to the sign in page" do
      visit student_courses_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "when is logged in" do
    before :each do
      login(student)

      visit student_courses_path
    end

    it "student can access the my courses page" do
      expect(page).to have_content('My Courses')
    end

    context "when not enrolled to course" do
      it "student can not see any course" do
        expect(page).to have_content("No course available !!!")
      end

      it "student can not access course which they are not eneolled" do
        visit student_batch_path(course_2)

        expect(page).to have_content('Page not found')
      end
    end

    context "when enrolled to course" do
      it "student can see their enrolled course" do
        enrollment.approved!

        visit student_courses_path

        expect(page).to have_content(course.name)
      end

      it "student can view the course details" do
        enrollment.approved!

        visit student_course_path(course)

        expect(page).to have_content('Batches')
        expect(page).to have_content(batch.name)
      end
    end
  end
end


