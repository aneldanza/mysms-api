class MessagesController < ApplicationController
  def index
    messages = Message.order_by(created_at: :desc)
    render json: messages, status: :ok
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      send_sms_via_twilio(@message)
      render json: @message, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:to, :body)
  end

  def send_sms_via_twilio
    @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])

    twilio_message = @client.messages.create(
      from: ENV["TWILIO_PHONE_NUMBER"],
      to: @message.to,
      body: @message.body,
    )

    @message.update(twilio_sid: twilio_message.sid, status: "sent")
  end
end
