require 'rails_helper'

RSpec.feature 'Admin', type: :feature do
  let!(:admin) { create(:user, :admin) }

  before do
    login(admin)
  end

  context 'Creating Schools' do
    it 'Admin can create new schools' do
      visit new_admin_school_path

      fill_in 'Name', with: 'New School'
      fill_in 'Address', with: 'New School Address'

      click_button 'Create School'

      expect(page).to have_content('School was successfully created.')
      expect(page).to have_content('New School')
      expect(page).to have_content('New School Address')
    end
  end

  context 'Creating Users' do
    it 'Admin can create new users' do
      visit new_admin_user_path

      fill_in 'Email', with: 'newuser@example.com'
      fill_in 'Password', with: 'password123'

      click_button 'Create User'

      expect(page).to have_content('User was successfully created.')
      expect(page).to have_content('newuser@example.com')
    end
  end

  context 'Managing Batches' do
    it 'Admin can create batches for any course' do
      course = create(:course)

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

    it 'Admin can manage enrollment requests for any batch' do
      enrollment = create(:enrollment)

      visit admin_enrollments_path

      expect(page).to have_content(enrollment.batch.name)

      click_link 'Approve'

      expect(page).to have_content('Enrollment request was successfully approved.')
      expect(page).to have_content('Approved')
    end
  end

  context 'Updating Schools' do
    it 'Admin can update any school' do
      school = create(:school)

      visit edit_admin_school_path(school)

      fill_in 'Name', with: 'Updated School Name'
      fill_in 'Address', with: 'New Address'

      click_button 'Update School'

      expect(page).to have_content('School was successfully updated.')
      expect(page).to have_content('Updated School Name')
      expect(page).to have_content('New Address')
    end
  end

  context 'Assigning School Admin' do
    it 'Admin can assign a school admin to a school' do
      school = create(:school)
      school_admin = create(:user, :school_admin)

      visit admin_school_path(school)

      click_link 'Manage School Admin'
      click_link 'Add School Admin'

      select school_admin.email, from: 'school_admin_user_id'

      click_button 'Create Admin'

      expect(page).to have_content('School Admin was successfully created.')
      expect(school.admins).to include(school_admin)
    end
  end

  context 'Restrictions' do
    it "Admin cannot access the student portal" do
      visit student_batches_path
  
      expect(current_path).to eq(admin_path)
    end
  end
end


