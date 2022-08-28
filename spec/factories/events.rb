# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    event_type { "click" }
    url { "https://example.com" }
  end
end
