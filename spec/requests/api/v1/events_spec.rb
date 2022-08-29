# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/api/v1/events", type: :request do
  describe 'GET /' do
    let(:url) { nil }
    let(:from) { nil }
    let(:to) { nil }
    let(:event_type) { nil }

    let(:url_params) do
      {
        url: url,
        from: from,
        to: to,
        event_type: event_type
      }
    end

    let!(:event) { create(:event) }
    subject { get "/api/v1/events", params: url_params }

    it 'responds with status ok' do
      subject

      expect(response).to have_http_status(:ok)
    end

    # @Todo(Tim): Replace with black box testing and more extensive test suite
    it 'calls the EventSearchForm#scope_query method to filter the results' do
      expect_any_instance_of(EventSearchForm).to receive(:scope_query)

      subject
    end

    it 'returns an array of events' do
      subject

      body = response.parsed_body

      expect(body).to be_instance_of(Array)
      expect(body.length).to eq(1)

      expect(body[0]['id']).to eq(event.id)
      expect(body[0]['event_type']).to eq(event.event_type)
      expect(body[0]['url']).to eq(event.url)
      expect(body[0]['created_at']).to be_instance_of(String)
      expect(body[0]['updated_at']).to be_instance_of(String)
    end

    context 'when event search params are invalid' do
      let(:event_type) { 'gibberish' }

      it 'returns a status 400' do
        subject

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message in the body' do
        subject

        body = response.parsed_body

        expect(body.keys).to eq(['event_type'])
        expect(body['event_type']).to eq(["is not included in the list"])
      end
    end
  end

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
