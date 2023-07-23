require 'rails_helper'

RSpec.feature type: :feature do
  let!(:student) { FactoryBot.create(:user, :student) }

  before :each do
    login(student)

    visit admin_path
  end

  it "student cannot access the admin panel" do
    expect(page).to have_content('Page not found')
  end
end

