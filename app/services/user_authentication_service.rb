class UserAuthenticationService
  require 'bcrypt'

  def verify_email_address(token:)
    authentication_token = AuthenticationToken.find_by(token: token)
    raise 'Token not found or already used' if authentication_token.nil? || authentication_token.used
    raise 'Token has expired' if authentication_token.expires_at < Time.current

    user = authentication_token.user
    if user.email_verified
      raise 'Email already verified'
    else
      user.update!(email_verified: true)
      authentication_token.update!(used: true)
      UserMailer.registration_confirmation(user).deliver_later
      'Email address has been successfully verified.'
    end
  rescue ActiveRecord::RecordInvalid => e
    raise e.message
  end

  def verify_and_set_password(token:, password:)
    authentication_token = AuthenticationToken.find_by(token: token)
    raise 'Token not found or already used' if authentication_token.nil? || authentication_token.used
    raise 'Token has expired' if authentication_token.expires_at < Time.current

    PasswordPolicyValidator.new.validate(password)
    encrypted_password = encrypt_password(password)

    user = authentication_token.user
    user.update!(password: encrypted_password)
    authentication_token.update!(used: true)

    'Email verification and password setup successful'
  rescue ActiveRecord::RecordInvalid => e
    raise e.message
  end

  def set_user_password(user_id:, password:)
    raise 'User ID and password must be present' if user_id.blank? || password.blank?

    PasswordPolicyValidator.new.validate(password)
    encrypted_password = encrypt_password(password)

    user = User.find_by(id: user_id)
    raise 'User not found' if user.nil?

    user.update!(password: encrypted_password)

    'Password has been set successfully'
  rescue ActiveRecord::RecordInvalid => e
    raise e.message
  end

  private

  def encrypt_password(password)
    BCrypt::Password.create(password)
  end
end
