# frozen_string_literal: true

class School < ApplicationRecord
  has_many :school_admins, class_name: 'School::Admin', dependent: :destroy
  has_many :admins, through: :school_admins, source: :user
  has_many :courses, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
  validates :address, presence: true, length: { maximum: 200 }

  scope :accessible, lambda { |user|
    if user&.has_role?(:school_admin)
      joins(:school_admins).where(school_admins: { user_id: user.id })
    else
      all
    end
  }

  scope :filtered, lambda { |name|
    schools = all

    schools = schools.where('schools.name LIKE ?', "%#{name}%") if name.present?

    schools
  }
end
