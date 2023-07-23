# frozen_string_literal: true

class CreateSchools < ActiveRecord::Migration[7.0]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.text :description, null: false

      t.timestamps null: false
    end
  end
end
