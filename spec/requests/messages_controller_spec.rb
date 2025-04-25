require 'rails_helper'

RSpec.describe "MessagesController", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /messages" do
    context "when authenticated" do
      let!(:messages) { create_list(:message, 3, user: user) }
      let!(:other_user) { create(:user) }
      let!(:other_user_messages) { create_list(:message, 2, user: other_user) }

      it "returns only the current user's messages in descending order" do
        get "/messages", headers: auth_headers
      
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

      
        expect(json.size).to eq(3) # Only the current user's messages
        expect(json.first["_id"]["$oid"]).to eq(messages.last["_id"].to_s) # Descending order
      end
    end

    context "when not authenticated" do
      it "returns error" do
        get "/messages"

        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "POST /messages" do
    let(:message_params) { { to: "+1234567890", body: "Hello, this is a test message!" } }

    context "when authenticated" do
      it "creates a new message and sends it via Twilio" do
        # Mock Twilio client
        twilio_client = instance_double(Twilio::REST::Client)
        messages_double = instance_double(Twilio::REST::Api::V2010::AccountContext::MessageList)
        allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
        allow(twilio_client).to receive(:messages).and_return(messages_double)
        allow(messages_double).to receive(:create).and_return(
          OpenStruct.new(sid: "SM12345", status: "queued")
        )

        post "/messages", params: { message: message_params }, headers: auth_headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)

        expect(json["to"]).to eq(message_params[:to])
        expect(json["body"]).to eq(message_params[:body])
        expect(json["twilio_sid"]).to eq("SM12345")
        expect(json["status"]).to eq("queued")
      end
    end

    context "when not authenticated" do
      it "returns error" do
        post "/messages", params: { message: message_params }

        expect(response).to have_http_status(302)
      end
    end

    context "when invalid parameters are provided" do
      it "returns unprocessable entity with error messages" do
        post "/messages", params: { message: { to: "", body: "" } }, headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["errors"]).to include("To can't be blank", "Body can't be blank")
      end
    end
  end
end