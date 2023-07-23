require 'rails_helper'

RSpec.feature 'Student Batches', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:batch) { FactoryBot.create(:batch) }
  let!(:enrollment) { FactoryBot.create(:enrollment, batch: batch, student: student) }

  before do
    login_as(student)
  end

  content 'Student can access the batches index page' do
    visit student_batches_path
    expect(page).to have_content(batch.name)
  end
end
