# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/api/v1/events", type: :request do
  describe "POST /" do
    let(:url) { Faker::Internet.url }
    let(:event_type) { "click" }
    let(:params) do
      {
        "event_type" => event_type,
        "url" => url
      }
    end

    subject do
      post "/api/v1/events", params: params
    end


    it "returns http success" do
      subject

      expect(response).to have_http_status(:created)
    end

    it 'stores a new event' do
      expect { subject }.to change(Event, :count).by(1)

      latest_event = Event.last

      expect(latest_event.url).to eq(url)
      expect(latest_event.event_type).to eq(event_type)
    end

    it 'returns an event json' do
      subject

      body = response.parsed_body

      expect(body['id']).to be_instance_of(Integer)
      expect(body["url"]).to eq(url)
      expect(body["event_type"]).to eq(event_type)
      expect(body["created_at"]).to be_instance_of(String)
    end

    context 'when parameter is invalid' do
      let(:event_type) { "" }

      it 'returns a bad request status code' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns a hash with errors' do
        subject

        body = response.parsed_body

        expect(body.keys).to eq(["event_type"])
        expect(body["event_type"]).to eq(["can't be blank", "is not included in the list"])
      end
    end
  end
end
