class UsersController < ApplicationController
  before_action :authenticate_user! 

  def me
    render json: {
        id: current_user.id,
        email: current_user.email,
        username: current_user.username,
        created_at: current_user.created_at,
        updated_at: current_user.updated_at,
    }
  end
end
