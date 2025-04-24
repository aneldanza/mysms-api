class UsersController < ApplicationController
  before_action :authenticate_user! 

  def me
    render json: {
        id: current_user.id.to_s,
        email: current_user.email,
        name: current_user.name,
        created_at: current_user.created_at,
        updated_at: current_user.updated_at,
    }
  end
end
