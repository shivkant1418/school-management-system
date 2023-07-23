# spec/models/batch_spec.rb
require 'rails_helper'

RSpec.describe Batch, type: :model do
  describe 'associations' do
    it { should belong_to(:course) }
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:students).through(:enrollments) }
  end

  describe 'validations' do
    subject { build(:batch) } # Use FactoryBot to build a new Batch object

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_uniqueness_of(:name).scoped_to(:course_id).case_insensitive }

    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    it 'validates start_date before end_date' do
      batch = build(:batch, start_date: '2023-09-01', end_date: '2023-06-30')
      expect(batch).not_to be_valid
      expect(batch.errors[:start_date]).to include('should be before end_date')
    end
  end

  describe 'scopes' do
    let(:school_admin_user) { create(:user, :school_admin) }
    let!(:school) { create(:school) }
    let!(:course) { create(:course, school: school) }
    let!(:batch_1) { create(:batch, course: course) }
    let!(:batch_2) { create(:batch) }

    it 'returns accessible batches for school_admin' do
      create(:school_admin, school: school, user: school_admin_user)

      accessible_batches = Batch.accessible(school_admin_user)
      expect(accessible_batches).to include(batch_1)
      expect(accessible_batches).not_to include(batch_2)
    end

    it 'filters batches by school_id, course_id, and name' do
      filtered_batches = Batch.filtered(school.id, course.id, batch_1.name)
      expect(filtered_batches).to eq([batch_1])
    end
  end
end
