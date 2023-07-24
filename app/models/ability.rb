# frozen_string_literal: true

# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user

    if user.has_role?(:admin)
      can :access, :admin_panel
      can :manage, :all # Admin can manage the whole application
    elsif user.has_role?(:school_admin)
      can :access, :admin_panel

      school_ids = user.school_admins.pluck(:school_id)

      can %i[read update], School, id: school_ids
      can :manage, Course, school_id: school_ids
      can :manage, Batch, course: { school_id: school_ids }
      can :manage, Enrollment, batch: { course: { school_id: school_ids } }
    else
      can :read, School
      can :read, Course, id: user.my_courses.ids
      can :read, CoursesController
      can :read, Api::V1::CoursesController
      can :read, Batch, course: { id: user.my_courses.ids }
      can %i[read create destroy], Enrollment, student: user
    end
  end
end
