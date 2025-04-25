require 'rails_helper'

RSpec.describe "Users::SessionsController", type: :request do
  let(:user) { create(:user) }


  let(:auth_headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { "Authorization" => "Bearer #{token}" }
  end

  describe "DELETE /users/sign_out" do
    context "when the user is logged in" do
      it "logs out the user and revokes the JWT" do
        delete "/users/sign_out", headers: auth_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["status"]["code"]).to eq(200)
        expect(json["status"]["message"]).to eq("Logged out successfully.")
      end
    end

    context "when the user is not logged in" do
      it "returns an unauthorized error" do
        delete "/users/sign_out"

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)

        expect(json["status"]["code"]).to eq(401)
        expect(json["status"]["message"]).to eq("User not logged in.")
        expect(json["errors"]).to include("No active session.")
      end
    end
  end

  describe "POST /users/sign_in" do
    context "when the credentials are valid" do
      it "logs in the user and returns a JWT" do
        post "/users/sign_in", params: { user: { email: user.email, password: user.password } }.to_json, headers: { "Content-Type" => "application/json", "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["status"]["code"]).to eq(200)
        expect(json["status"]["message"]).to eq("Logged in successfully.")
        expect(json["data"]["email"]).to eq(user.email)
      end
    end

    context "when the credentials are invalid" do
      it "returns an unauthorized error" do
        post "/users/sign_in", params: { user: { email: user.email, password: "wrongpassword" } }

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)

        expect(json["error"]).to eq("Invalid Email or password.")
      end
    end
  end
end