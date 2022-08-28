# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/api/v1/docs", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/api/v1/docs"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /openapi.yml" do
    it "returns http success" do
      get "/api/v1/docs/openapi.yml"
      expect(response).to have_http_status(:success)
    end
  end
end
