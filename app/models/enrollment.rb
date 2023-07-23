# frozen_string_literal: true

class Enrollment < ApplicationRecord
  include AASM

  default_scope { order(created_at: :desc) }

  belongs_to :student, class_name: 'User'
  belongs_to :batch

  validate :validate_student_enrollment_limit, on: :create

  enum status: {
    pending: 401,
    rejected: 402,
    approved: 403
  }

  aasm column: :status, enum: true, whiny_transitions: false do
    state :pending, initial: true
    state :approved, :rejected

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end

  scope :accessible, lambda { |user|
    if user&.has_role?(:school_admin)
      joins(batch: { course: :school }).where(schools: { id: user.schools.pluck(:id) })
    elsif user&.has_role?(:student)
      where(student: user)
    else
      all
    end
  }

  scope :filtered, lambda { |school_id, course_id, batch_id, student_id, status|
    enrollments = includes(:student, batch: { course: :school }).order(created_at: :desc)

    enrollments = enrollments.where(batches: { courses: { school_id: school_id } }) if school_id.present?
    enrollments = enrollments.where(batches: { course_id: course_id }) if course_id.present?
    enrollments = enrollments.where(batch: batch_id) if batch_id.present?
    enrollments = enrollments.where(student_id: student_id) if student_id.present?

    enrollments = enrollments.where(status: status) if status.present?

    enrollments
  }

  private

  def validate_student_enrollment_limit
    return true unless student.present? && batch.present?

    # Check if the student is already enrolled in the course
    if student.enrollments.where(batch: batch).approved.exists?
      errors.add(:base, 'You are already enrolled in this course.')
    end

    # Check if there are any pending enrollment requests for the same batch and course
    return unless Enrollment.where(student: student, batch: batch).pending.exists?

    errors.add(:base, 'You already have a pending enrollment request for this course.')
  end
end
