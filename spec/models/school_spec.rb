require 'rails_helper'

RSpec.describe School, type: :model do
  describe 'associations' do
    it { should have_many(:school_admins).class_name('School::Admin').dependent(:destroy) }
    it { should have_many(:admins).through(:school_admins).source(:user) }
    it { should have_many(:courses).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:school) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_presence_of(:address) }
    it { should validate_length_of(:address).is_at_most(200) }
  end

  describe 'scopes' do
    let!(:school_admin) { create(:user, :school_admin) }
    let!(:school1) { create(:school) }
    let!(:school2) { create(:school) }
    let!(:school3) { create(:school) }

    before do
      create(:school_admin, user: school_admin, school: school1)
    end

    describe '.accessible' do
      it 'returns schools accessible to the school_admin user' do
        accessible_schools = School.accessible(school_admin)
        expect(accessible_schools).to eq([school1])
      end

      it 'returns all schools when the user is not a school_admin' do
        accessible_schools = School.accessible(nil)
        expect(accessible_schools).to match_array([school1, school2, school3])
      end
    end

    describe '.filtered' do
      it 'returns schools filtered by name' do
        filtered_schools = School.filtered(school1.name)
        expect(filtered_schools).to eq([school1])
      end

      it 'returns all schools when no name is provided for filtering' do
        filtered_schools = School.filtered(nil)
        expect(filtered_schools).to match_array([school1, school2, school3])
      end
    end
  end
end
