class TwilioController < ApplicationController
  protect_from_forgery with: null_session

  def status
    sid = params[:MessageSid]
    status = params[:MessageStatus]

    message = Message.find_by(twilio_sid: sid)

    # Broadcast the new status
    ActionCable.server.broadcast(
      "message_status",
      {
        id: message.id.to_s,
        status: message.status
      }
    )

    if message
      message.update(status: status)
      head :ok
    else
      Rails.logger.error("Message with SID #{sid} not found.")
      head :not_found
    end
  end
end
