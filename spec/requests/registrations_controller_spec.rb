require 'rails_helper'

RSpec.describe "Users::RegistrationsController", type: :request do
  describe "POST /users" do
    let(:valid_params) do
      {
        user: {
          email: "test3@example.com",
          username: "testuser3",
          password: "password3",
          password_confirmation: "password3"
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email: "",
          username: "",
          password: "password",
          password_confirmation: "mismatch"
        }
      }
    end

    context "when the parameters are valid" do
      it "creates a new user and returns a JWT" do
        post "/users", params: valid_params.to_json, headers: { "Content-Type" => "application/json", "Accept" => "application/json" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["status"]["code"]).to eq(200)
        expect(json["status"]["message"]).to eq("Signed up successfully.")
        expect(json["data"]["email"]).to eq("test3@example.com")
        expect(json["data"]["username"]).to eq("testuser3")
      end
    end

    context "when the parameters are invalid" do
      it "returns an error with validation messages" do
        post "/users", params: invalid_params.to_json, headers: { "Content-Type" => "application/json", "Accept" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["status"]["code"]).to eq(422)
        expect(json["status"]["message"]).to eq("User could not be created")
        expect(json["errors"]).to include("Email can't be blank", "Username can't be blank", "Password confirmation doesn't match Password")
      end
    end

    context "when the JWT token cannot be created" do
      before do
        allow_any_instance_of(Warden::JWTAuth::UserEncoder).to receive(:call).and_return(nil)
      end

      it "returns an internal server error" do
        post "/users", params: valid_params.to_json, headers: { "Content-Type" => "application/json", "Accept" => "application/json" }

        expect(response).to have_http_status(:internal_server_error)
        json = JSON.parse(response.body)

        expect(json["status"]["code"]).to eq(500)
        expect(json["status"]["message"]).to eq("Sign up failed")
        expect(json["errors"]).to include("JWT token could not be created. Please try again.")
      end
    end
  end
end