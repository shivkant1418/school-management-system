require 'rails_helper'

RSpec.feature 'School Admins', type: :feature do
  let!(:school_admin) { create(:user, :school_admin) }
  let!(:school) { create(:school) }
  let!(:course) { create(:course, school: school) }
  let!(:batch) { create(:batch, course: course) }

  before do
    create(:school_admin, user: school_admin, school: school)
    login(school_admin)
  end

  context 'Creating Courses' do
    it 'School admin can create courses for their school' do
      visit new_admin_course_path(school_id: school)

      fill_in 'Name', with: 'New Course'
      fill_in 'Description', with: 'Description of the new course'

      click_button 'Create Course'

      expect(page).to have_content('Course was successfully created.')
      expect(page).to have_content('New Course')
      expect(page).to have_content('Description of the new course')
    end

    it 'School admin cannot create courses for other schools' do
      another_school = create(:school)

      visit new_admin_course_path(school_id: another_school)

      fill_in 'Name', with: 'New Course'
      fill_in 'Description', with: 'Description of the new course'

      click_button 'Create Course'

      expect(page).to have_content('School must exist')
    end
  end

  context 'Updating School' do
    it 'School admin can update their school' do
      visit edit_admin_school_path(school)

      fill_in 'Name', with: 'Updated School Name'
      fill_in 'Address', with: 'New Address'

      click_button 'Update School'

      expect(page).to have_content('School was successfully updated.')
      expect(page).to have_content('Updated School Name')
      expect(page).to have_content('New Address')
    end

    it 'School admin cannot update other schools' do
      another_school = create(:school)

      visit edit_admin_school_path(another_school)

      expect(page).to have_content('Page not found.')
    end
  end

  context 'Creating Batches' do
    it 'School admin can create batches for their courses only' do
      visit new_admin_batch_path(course_id: course)

      fill_in 'Name', with: 'New Batch'
      fill_in 'batch[start_date]', with: '2023-08-01'
      fill_in 'batch[end_date]', with: '2023-12-31'
      fill_in 'Description', with: 'Description of the new batch'

      click_button 'Create Batch'

      expect(page).to have_content('Batch was successfully created.')
      expect(page).to have_content('New Batch')
      expect(page).to have_content('Description of the new batch')
    end

    it 'School admin cannot create batches for other courses' do
      another_course = create(:course)

      visit new_admin_batch_path(course_id: another_course)

      fill_in 'Name', with: 'New Batch'
      fill_in 'batch[start_date]', with: '2023-08-01'
      fill_in 'batch[end_date]', with: '2023-12-31'
      fill_in 'Description', with: 'Description of the new batch'

      click_button 'Create Batch'

      expect(page).to have_content('Course must exist')
    end
  end

  context 'Managing enrollment Requests' do
    it 'School admin can manage requests for their batches only' do
      enrollment = create(:enrollment, batch: batch)

      visit admin_enrollments_path

      expect(page).to have_content(enrollment.batch.name)

      click_link 'Approve'

      expect(page).to have_content('Enrollment request was successfully approved.')
      expect(page).to have_content('Approved')
    end

    it 'School admin cannot manage requests for other batches' do
      enrollment = create(:enrollment)

      visit admin_enrollments_path

      expect(page).not_to have_content(enrollment.batch.name)
    end
  end

  context 'Restrictions' do
    it 'School admin cannot create new schools' do
      visit new_admin_school_path

      expect(page).to have_content('Page not found.')
    end

    it 'School admin cannot create new users' do
      visit new_admin_user_path

      expect(page).to have_content('Page not found.')
    end

    it 'School admin cannot assign new school admins' do
      visit admin_school_admins_path(create(:school))

      expect(page).to have_content('Page not found.')
    end

    it "School admin cannot access the student portal" do
      visit student_batches_path
  
      expect(current_path).to eq(admin_path)
    end
  end
end
