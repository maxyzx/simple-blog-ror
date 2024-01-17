class PasswordsController < ApplicationController
  before_action :validate_password_reset_token, only: [:reset]

  def reset
    token = params[:token]
    validation_result = validate_password_reset_token(token)

    if validation_result[:valid]
      # Allow user to set a new password
      # Code for resetting the password will go here
    else
      render json: { message: validation_result[:message] }, status: :unprocessable_entity
    end
  end
end
