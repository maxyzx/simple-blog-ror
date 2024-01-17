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

  # POST /api/users
  def create
    # Validate user_params before attempting to register the user
    validator = UserValidator.new(user_params)
    unless validator.valid?
      render json: { errors: validator.errors }, status: :bad_request
      return
    end

    # Check if the email is already in use
    if User.exists?(email: user_params[:email])
      render json: { error: 'Email is already in use' }, status: :conflict
      return
    end

    # Attempt to register the user
    result = UserRegistrationService.register_user(user_params)
    if result.success?
      user = result.user
      render json: { status: 201, user: user_response(user) }, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_password_reset_token
    @password_reset_token = PasswordResetToken.find_by(token: params[:token])
  end

  def user_params
    params.require(:user).permit(:email, :password, :display_name, :date_of_birth, :gender)
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      display_name: user.display_name,
      date_of_birth: user.date_of_birth,
      gender: user.gender,
      status: user.status
    }
  end
end
