class Api::V1::UsersController < ApplicationController
  include PasswordResetService
  include PasswordPolicyValidator
  include PasswordEncryptor

  # PUT /api/users/set_password
  def set_password
    token = params[:token]
    password = params[:password]

    # Validate the presence of token and password
    unless token.present? && password.present?
      return render json: { message: 'Token and password are required.' }, status: :bad_request
    end

    validation_result = validate_password_reset_token(token)

    if validation_result[:valid]
      begin
        PasswordPolicyValidator.validate_password_policy(password)
        reset_result = reset_password(validation_result[:user_id], password, validation_result[:token_id])
        if reset_result[:status] == 'success'
          render json: { message: 'Password has been set successfully.' }, status: :ok
        else
          render json: { message: reset_result[:message] }, status: :internal_server_error
        end
      rescue ArgumentError => e
        render json: { message: e.message }, status: :unprocessable_entity
      end
    else
      render json: { message: validation_result[:message] }, status: :not_found
    end
  end

  # ... other controller actions ...
end
