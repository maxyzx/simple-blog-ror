class UsersController < ApplicationController
  before_action :set_user, only: [:verify_email_and_set_password]
  before_action :find_user, only: [:agree_to_policies]

  def create
    @user = User.new(user_params)
    @user.is_customer = true
    if @user.save
      token = AuthenticationToken.generate_unique_token_for(@user)
      if token.save
        UserMailer.registration_confirmation(@user, token).deliver_later
        render json: { message: 'Account creation link has been sent to your email.' }, status: :created
      else
        render json: { errors: token.errors.full_messages }, status: :unprocessable_entity
      end
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
      # Create privacy policy agreement
      privacy_policy_agreement = PrivacyPolicyAgreement.new(user_id: @user.id, agreed_at: DateTime.now)
      unless privacy_policy_agreement.save
        render json: { error: privacy_policy_agreement.errors.full_messages.join(', ') }, status: :unprocessable_entity
        return
      end

      # Create terms of use agreement
      terms_of_use_agreement = TermsOfUseAgreement.new(user_id: @user.id, agreed_at: DateTime.now)
      unless terms_of_use_agreement.save
        render json: { error: terms_of_use_agreement.errors.full_messages.join(', ') }, status: :unprocessable_entity
        return
      end

      render json: { message: 'User has successfully agreed to the policies.' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def verify_email_address
    token = params[:token]
    begin
      message = UserAuthenticationService.new.verify_email_address(token: token)
      render json: { success: true, message: message }, status: :ok
    rescue => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
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
