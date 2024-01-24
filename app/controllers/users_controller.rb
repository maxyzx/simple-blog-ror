class UsersController < ApplicationController
  before_action :set_user, only: [:verify_email_and_set_password]
  before_action :find_user, only: [:agree_to_policies]

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

  def agree_to_policies
    begin
      PrivacyPolicyAgreement.create!(user_id: @user.id, agreed_at: DateTime.now)
      TermsOfUseAgreement.create!(user_id: @user.id, agreed_at: DateTime.now)
      render json: { message: 'User has successfully agreed to the policies.' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def set_password
    user_id = params[:user_id]
    password = params[:password]
    begin
      message = UserAuthenticationService.new.set_user_password(user_id: user_id, password: password)
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

  def find_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:email, :password, :display_name, :date_of_birth, :gender)
  end
end
