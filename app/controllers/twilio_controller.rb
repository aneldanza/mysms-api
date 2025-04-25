class TwilioController < ApplicationController
  def status
    sid = params[:MessageSid]
    status = params[:MessageStatus]

    message = Message.find_by(twilio_sid: sid)

    if message
      message.update(status: status)
      head :ok
    else
      Rails.logger.error("Message with SID #{sid} not found.")
      head :not_found
    end
  end
end
