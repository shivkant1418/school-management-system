# frozen_string_literal: true

class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.references :batch, null: false, foreign_key: true
      t.integer :status, null: false
      t.integer :student_id, null: false

      t.timestamps null: false
    end
  end
end
