class UsersController < ApplicationController
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
end
