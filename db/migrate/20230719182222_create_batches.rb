# frozen_string_literal: true

class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.references :course, null: false, foreign_key: true

      t.string :name, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.text :description, null: false

      t.timestamps null: false
    end
  end
end
