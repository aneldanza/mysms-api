class HealthController < ApplicationController::API
  def index
    def index
      render json: { status: 'ok' }, status: :ok
    end
  end
end
