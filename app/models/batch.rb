# frozen_string_literal: true

class Batch < ApplicationRecord
  belongs_to :course

  has_many :enrollments, -> { where(enrollments: { status: 'approved' }) }, dependent: :destroy
  has_many :students, through: :enrollments

  validates :name, presence: true, uniqueness: { scope: :course_id, case_sensitive: false }, length: { maximum: 100 }

  validates :start_date, :end_date, presence: true

  validate :start_date_before_end_date

  scope :accessible, lambda { |user|
    if user&.has_role?(:school_admin)
      joins(course: :school).where(schools: { id: user.schools.pluck(:id) })
    else
      all
    end
  }

  scope :filtered, lambda { |school_id, course_id, name|
    batches = includes(course: :school).order(created_at: :desc)

    batches = batches.where(courses: { school_id: school_id }) if school_id.present?
    batches = batches.where(course_id: course_id) if course_id.present?
    batches = batches.where('batches.name LIKE ?', "%#{name}%") if name.present?

    batches
  }

  private

  def start_date_before_end_date
    return unless start_date.present? && end_date.present? && start_date >= end_date

    errors.add(:start_date, 'should be before end_date')
  end
end
