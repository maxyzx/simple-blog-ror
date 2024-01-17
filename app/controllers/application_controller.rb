class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def validate_request(request_id)
    Request.exists?(request_id)
  end

  def validate_password_reset_token(token)
    password_reset_token = PasswordResetToken.find_by(token: token)
    if password_reset_token.nil?
      { valid: false, message: 'Invalid token' }
    elsif password_reset_token.used
      { valid: false, message: 'Token already used' }
    elsif password_reset_token.expires_at < Time.current
      { valid: false, message: 'Token expired' }
    else
      { valid: true, message: 'Valid token' }
    end
  end
end
