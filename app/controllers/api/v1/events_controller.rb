# frozen_string_literal: true

class Api::V1::EventsController < Api::V1::BaseController
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
end
