class UsersController < ApplicationController
  before_action :set_password_reset_token, only: [:validate_token]

  # GET /api/users/validate_token/:token
  def validate_token
    if @password_reset_token.nil?
      render json: { message: 'Token does not exist' }, status: :not_found
    elsif @password_reset_token.expired?
      render json: { message: 'Token is expired' }, status: :not_found
    else
      render json: { status: 200, message: 'The token is valid.' }, status: :ok
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end

  private
    def set_password_reset_token
      @password_reset_token = PasswordResetToken.find_by(token: params[:token])
    end
end
