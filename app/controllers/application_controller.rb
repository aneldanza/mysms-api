class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Override Devise's behavior for unauthenticated requests
  rescue_from Warden::NotAuthenticated do
    render json: { error: 'You need to sign in or sign up before continuing.' }, status: :unauthorized
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
