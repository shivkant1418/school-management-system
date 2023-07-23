require 'rails_helper'

RSpec.feature "Home" do
  let!(:student) { FactoryBot.create(:user, :student) }

  before :each do
    login(student)

    visit root_path
  end

  it "student can access the home page" do
    expect(page).to have_content('Welcome to our School App!')
    expect(page).not_to have_content('Login')
    expect(page).to have_selector("a#dropdownUser1")
  end
end

