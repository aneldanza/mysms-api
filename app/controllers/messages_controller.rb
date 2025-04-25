class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    messages = Message.where(user_id: current_user.id).order_by(created_at: :desc)
  
    render json: messages, status: :ok
  end

  def create
    message = current_user.messages.build(message_params)
    if message.save
      send_sms_via_twilio(message)
      render json: message, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:to, :body)
  end

  def send_sms_via_twilio(message)
    @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])

    twilio_message = @client.messages.create(
      from: ENV["TWILIO_FROM_PHONE_NUMBER"],
      to: message.to || ENV["TWILIO_TO_PHONE_NUMBER"],
      body: message.body,
      status_callback: "#{ENV["BASE_URL"]}/twilio/status",
    )

    message.update(twilio_sid: twilio_message.sid, status: twilio_message.status)
  end
end
