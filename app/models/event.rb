# frozen_string_literal: true

class Event < ApplicationRecord
  EVENT_TYPES = %w(
    click
    page_view
  )

  validates :event_type, presence: true
  validates :event_type, inclusion: { in: EVENT_TYPES }

  validates :url, presence: true

  validate :is_valid_url

  private

  def is_valid_url
    URI.parse(url)
  rescue URI::InvalidURIError
    errors.add(:url, "not a valid url")
  end
end
