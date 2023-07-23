require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe 'associations' do
    it { should belong_to(:student).class_name('User') }
    it { should belong_to(:batch) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 401, rejected: 402, approved: 403) }
  end

  describe 'scopes' do
    let!(:school_admin_user) { create(:user, :school_admin) }
    let!(:student) { create(:user, :student) }
    let!(:school) { create(:school) }
    let!(:course) { create(:course, school: school) }
    let!(:batch) { create(:batch, course: course) }
    let!(:enrollment) { create(:enrollment, student: student, batch: batch) }
    let!(:enrollment_2) { create(:enrollment, status: "approved") }

    describe '.accessible' do
      it 'returns enrollments for school admin that belong to schools they manage' do
        create(:school_admin, school: school, user: school_admin_user)
        accessible_enrollments = Enrollment.accessible(school_admin_user)
        expect(accessible_enrollments).to eq([enrollment])
      end

      it 'returns enrollments for a specific student' do
        accessible_enrollments = Enrollment.accessible(student)
        expect(accessible_enrollments).to eq([enrollment])
      end

      it 'returns all enrollments when no user is provided' do

        accessible_enrollments = Enrollment.accessible(nil)
        expect(accessible_enrollments).to match_array([enrollment, enrollment_2])
      end
    end

    describe '.filtered' do
      it 'returns enrollments filtered by school_id' do
        filtered_enrollments = Enrollment.filtered(school.id, nil, nil, nil, nil)
        expect(filtered_enrollments).to eq([enrollment])
      end

      it 'returns enrollments filtered by course_id' do
        filtered_enrollments = Enrollment.filtered(nil, course.id, nil, nil, nil)
        expect(filtered_enrollments).to eq([enrollment])
      end

      it 'returns enrollments filtered by batch_id' do
        filtered_enrollments = Enrollment.filtered(nil, nil, batch.id, nil, nil)
        expect(filtered_enrollments).to eq([enrollment])
      end

      it 'returns enrollments filtered by student_id' do
        filtered_enrollments = Enrollment.filtered(nil, nil, nil, student.id, nil)
        expect(filtered_enrollments).to eq([enrollment])
      end

      it 'returns enrollments filtered by status' do
        filtered_enrollments = Enrollment.filtered(nil, nil, nil, nil, Enrollment.statuses[:approved])
        expect(filtered_enrollments).to eq([enrollment_2])
      end
    end
  end

  describe 'aasm' do
    let!(:enrollment) { create(:enrollment) }

    it 'starts in the pending state' do
      expect(enrollment).to be_pending
    end

    it 'transitions to approved state' do
      enrollment.approve!
      expect(enrollment).to be_approved
    end

    it 'transitions to rejected state' do
      enrollment.reject!
      expect(enrollment).to be_rejected
    end
  end

  describe 'validate_student_enrollment_limit' do
    let!(:student) { create(:user, :student) }
    let!(:batch) { create(:batch) }

    it 'adds error when student is already enrolled in the course' do
      create(:enrollment, student: student, batch: batch, status: :approved)

      enrollment = build(:enrollment, student: student, batch: batch, status: :pending)

      enrollment.send(:validate_student_enrollment_limit)

      expect(enrollment.errors[:base]).to include('You are already enrolled in this course.')
    end

    it 'adds error when student already has a pending enrollment request for the course' do
      create(:enrollment, student: student, batch: batch, status: :pending)

      enrollment = build(:enrollment, student: student, batch: batch, status: :pending)

      enrollment.send(:validate_student_enrollment_limit)

      expect(enrollment.errors[:base]).to include('You already have a pending enrollment request for this course.')
    end

    it 'does not add error when student is not enrolled in the course' do
      enrollment = build(:enrollment, student: student, batch: batch, status: :pending)

      enrollment.send(:validate_student_enrollment_limit)

      expect(enrollment.errors[:base]).to be_empty
    end
  end
end
