require 'rails_helper'

RSpec.feature 'Courses', type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }
  let!(:batch) { FactoryBot.create(:batch) }

  before :each do
    login(student)

    visit batches_path
  end

  it "student can access the batches index page" do
    expect(page).to have_content(batch.name)
  end

  it "student can send request for batch enrollment" do
    click_link "Enroll for course"

    expect(page).to have_content("Your enrollment request sent to school!")
  end
end

