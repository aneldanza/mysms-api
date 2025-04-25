require 'rails_helper'

RSpec.describe "TwilioController", type: :request do
  describe "POST /twilio/status" do
    let(:message) { create(:message, twilio_sid: "SM12345", status: "queued", to: "+1234567890", body: "Test message body" ) }

    context "when the message exists" do
      it "updates the message status and broadcasts the new status" do
      
        expect(ActionCable.server).to receive(:broadcast).with(
          "message_status",
          {
            id: message.id.to_s,
            status: "delivered"
          }
        )
      
        post "/twilio/status", params: { MessageSid: "SM12345", MessageStatus: "delivered" }
      
        expect(response).to have_http_status(:ok)
        expect(message.reload.status).to eq("delivered")
      end
    end

    context "when the message does not exist" do
      it "returns a 404 not found status" do
        post "/twilio/status", params: { MessageSid: "SM99999", MessageStatus: "delivered" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end