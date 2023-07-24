# frozen_string_literal: true

class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :school_admins, class_name: 'School::Admin', dependent: :destroy
  has_many :schools, through: :school_admins

  has_many :enrollments, dependent: :destroy, foreign_key: :student_id

  has_many :approved_batches, -> { where(enrollments: { status: 'approved' }) }, through: :enrollments, source: :batch
  has_many :my_courses, -> { distinct }, through: :approved_batches, source: :course
  has_many :my_schools, -> { distinct }, through: :my_courses, source: :school

  after_create :assign_default_role

  scope :filtered, lambda { |role_id, email|
    users = includes(:roles).order('users.created_at DESC')

    users = users.where(roles: { id: role_id }) if role_id.present?

    users = users.where('users.email LIKE ?', "%#{email}%") if email.present?

    users
  }

  def add_role(role)
    roles.delete_all if roles.any? and !has_role?(role)

    super
  end

  def enrolled_for?(batch)
    enrollments.where(batch: batch).approved.exists?
  end

  def request_pending_for?(batch)
    enrollments.where(batch: batch).pending.exists?
  end

  def applied_before?(batch)
    enrollments.where(batch: batch).rejected.exists?
  end

  def class_mates_for(batch)
    batch.students.where.not(id: id)
  end

  private

  def assign_default_role
    add_role(:student) if roles.blank?
  end
end
