# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :school, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
