# frozen_string_literal: true

class AddIndexToEventsCreatedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :events, :created_at
  end
end
