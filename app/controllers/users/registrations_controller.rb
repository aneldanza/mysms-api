# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.valid?
      resource.save
      sign_in(resource_name, resource, store: false)

      token = request.env["warden-jwt_auth.token"]

      if token
        render json: {
                 status: { code: 200, message: "Signed up successfully." },
                 data: resource,
               }, status: :ok
      else
        resource.destroy
        render json: {
                 status: { code: 500, message: "Sign up failed" },
                 errors: ["JWT token could not be created. Please try again."],
               }, status: :internal_server_error
      end
    else
      clean_up_passwords(resource)

      render json: {
               status: { code: 422, message: "User could not be created" },
               errors: resource.errors.full_messages,
             }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
