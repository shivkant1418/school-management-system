# spec/models/course_spec.rb
require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'associations' do
    it { should belong_to(:school) }
    it { should have_many(:batches).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:course) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_length_of(:description).is_at_most(500) }

    it { should validate_uniqueness_of(:name).scoped_to(:school_id).case_insensitive }
  end

  describe 'scopes' do
    let!(:school_admin_user) { create(:user, :school_admin) }
    let!(:school) { create(:school) }
    let!(:course_1) { create(:course, school: school) }
    let!(:course_2) { create(:course) }

    it 'returns accessible courses for school_admin' do
      create(:school_admin, school: school, user: school_admin_user)

      accessible_courses = Course.accessible(school_admin_user)
      expect(accessible_courses).to include(course_1)
      expect(accessible_courses).not_to include(course_2)
    end

    it 'filters courses by school_id and name' do
      filtered_courses = Course.filtered(school.id, course_1.name)
      expect(filtered_courses).to eq([course_1])
    end
  end
end

