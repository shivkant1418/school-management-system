# frozen_string_literal: true

class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  validates :name, inclusion: { in: %w[student school_admin admin] }, allow_nil: true

  scopify

  class << self
    %w[student admin school_admin].each do |role|
      define_method role.to_s do
        ::Role.find_by(name: role)
      end
    end
  end
end
