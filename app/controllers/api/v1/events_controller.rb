# frozen_string_literal: true

class Api::V1::EventsController < Api::V1::BaseController

  def index
    event_search_form = EventSearchForm.new(event_search_params)

    if event_search_form.valid?
      # @Todo(Tim): Add pagination
      events = event_search_form.scope_query(Event.all)
      render json: events
    else
      render json: event_search_form.errors, status: :bad_request
    end
  end

  def create
    event = Event.new(event_create_params)

    if event.valid?
      event.save!
      render json: event, status: :created
    else
      render json: event.errors, status: :bad_request
    end
  end

  private

  def event_create_params
    params.permit(:event_type, :url)
  end

  def event_search_params
    params.permit(:from, :to, :url, :event_type)
  end
end
