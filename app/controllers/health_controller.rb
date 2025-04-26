class HealthController < ApplicationController
  def index
    def index
      render json: { status: 'ok' }, status: :ok
    end
  end
end
