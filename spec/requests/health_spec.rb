require 'rails_helper'

RSpec.describe "Healths", type: :request do
  describe "GET /index" do
    it "returns http ok" do
      get "/health"
      expect(response).to have_http_status(:ok)
    end
  end

end
