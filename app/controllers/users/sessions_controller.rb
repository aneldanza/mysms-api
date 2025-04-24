# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # DELETE /resource/sign_out
  def destroy
    if current_user
      # JWT will be revoked here via JTIMatcher
      sign_out(current_user)

      render json: {
               status: { code: 200, message: "Logged out successfully." },
             }, status: :ok
    else
      render json: {
               status: { code: 401, message: "User not logged in." },
               errors: ["No active session."],
             }, status: :unauthorized
    end
  end

  # ⛔ Prevent Devise from accessing the session
  def verify_signed_out_user
    # do nothing
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: "Logged in successfully." },
      data: resource,
    }, status: :ok
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
