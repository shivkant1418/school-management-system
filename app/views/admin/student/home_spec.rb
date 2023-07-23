require 'rails_helper'

RSpec.feature "Student Home" do
  context "when is logged out" do
    it "renders properly" do
      visit root_path

      expect(page).to have_content('Welcome to our School App!')
      expect(page).to have_content('Login')
    end
  end

  context "when is logged in" do
    let!(:student) { FactoryBot.create(:user, :student) }

    before :each do
      login(user)

      visit root_path
    end

    it "renders properly" do
      visit home_path

      expect(page).to have_content('Welcome to our School App!')
      expect(page).not_to have_content('Login')
      expect(page).to have_selector("a#dropdownUser1")
    end
  end
end

