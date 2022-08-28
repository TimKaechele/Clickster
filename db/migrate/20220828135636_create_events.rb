# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :event_type, null: false
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
