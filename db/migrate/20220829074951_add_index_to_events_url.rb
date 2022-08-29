# frozen_string_literal: true

class AddIndexToEventsUrl < ActiveRecord::Migration[7.0]
  def change
    add_index :events, :url
  end
end
