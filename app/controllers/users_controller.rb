class UsersController < ApplicationController
  before_action :set_user, only: [:verify_email_and_set_password]

  def create
    @user = User.new(user_params)
    @user.is_customer = true
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_later
      render json: { message: 'User successfully registered' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def verify_email_and_set_password
    token = params[:token]
    password = params[:password]
    begin
      message = UserAuthenticationService.new.verify_and_set_password(token: token, password: password)
      render json: { success: true, message: message }, status: :ok
    rescue => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    # Assuming there's a method to find a user by some means (e.g., by token)
    # This is just a placeholder for the actual implementation
    @user = User.find_by_token(params[:token])
  end

  def user_params
    params.require(:user).permit(:email, :password, :display_name, :date_of_birth, :gender)
  end
end
