require 'rails_helper'

RSpec.feature 'Student Enrollments', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:course) { FactoryBot.create(:course) }
  let!(:batch) { FactoryBot.create(:batch, course: course) }
  let!(:batch_2) { FactoryBot.create(:batch) }
  let!(:enrollment) { FactoryBot.create(:enrollment, student: student, batch: batch) }

  context "when is logged out" do
    it "redirects student to the sign in page" do
      visit student_batches_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "when is logged in" do
    before :each do
      login(student)

      visit student_batches_path
    end

    it "student can access the my batches page" do
      expect(page).to have_content('My Batches')
    end

    context "when not enrolled to batch" do
      it "student can not see any batch" do
        expect(page).to have_content("No batch available !!!")
      end

      it "student can not access batch which they are not eneolled" do
        visit student_batch_path(batch_2)

        expect(page).to have_content('Page not found')
      end
    end

    context "when enrolled to batch" do
      it "student can see the enrolled batch" do
        enrollment.approved!

        visit student_batches_path

        expect(page).to have_content(batch.name)
      end

      it "student can view their classmates and their progress" do
        enrollment.approved!

        visit student_batch_path(batch)

        expect(page).to have_content('Classmates and their progress:')
      end
    end
  end
end


