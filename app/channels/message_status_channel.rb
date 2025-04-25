class MessageStatusChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "message_status"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
