# frozen_string_literal: true

class School::Admin < ApplicationRecord
  belongs_to :user
  belongs_to :school

  validates_uniqueness_of :user, scope: :school, message: "is already associated with this school."
end
