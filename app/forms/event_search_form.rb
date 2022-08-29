# frozen_string_literal: true

class EventSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes

  attribute :event_type, :string
  attribute :url, :string
  attribute :from, :datetime
  attribute :to, :datetime

  # @Todo(Tim): Add validation for url

  validates :event_type, inclusion: { in: Event::EVENT_TYPES }, allow_blank: true
  validate :valid_order_of_timerange_query

  def valid_order_of_timerange_query
    return if from.blank?
    return if to.blank?
    return if from <= to

    errors.add(:from, "must be before to parameter")
  end

  def time_range
    return from..to if from.present? && to.present?
    return (from..) if from.present?
    return (..to) if to.present?

    nil
  end

  # Todo(Tim): Scoping should be refactored to happen somewhere else in order to make
  # the form really only concerned about accepting and verifying the different parameters
  def scope_query(collection)
    scoped_collection = collection

    scoped_collection = scoped_collection.where(url: url) if url.present?
    scoped_collection = scoped_collection.where(event_type: event_type) if event_type.present?
    scoped_collection = scoped_collection.where(created_at: time_range) if time_range.present?

    scoped_collection
  end
end
