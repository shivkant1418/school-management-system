# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :school

  has_many :batches, dependent: :destroy

  validates :name, :description, presence: true
  validates :name, uniqueness: { scope: :school_id, case_sensitive: false }

  validates :name, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }

  scope :accessible, lambda { |user|
    if user&.has_role?(:school_admin)
      joins(:school).where(schools: { id: user.schools.pluck(:id) })
    else
      all
    end
  }

  scope :filtered, lambda { |school_id, name|
    courses = includes(:school).order(created_at: :desc)

    courses = courses.where(school_id: school_id) if school_id.present?
    courses = courses.where('courses.name LIKE ?', "%#{name}%") if name.present?

    courses
  }
end
