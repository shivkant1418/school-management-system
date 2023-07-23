# frozen_string_literal: true

class CreateSchoolAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :school_admins do |t|
      t.references :user, foreign_key: true, index: true
      t.references :school, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
