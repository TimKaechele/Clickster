# frozen_string_literal: true

class AddIndexToEventsEventType < ActiveRecord::Migration[7.0]
  def change
    add_index :events, :event_type
  end
end
