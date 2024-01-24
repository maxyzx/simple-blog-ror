
class UserAuthenticationService
  def verify_and_set_password(token:, password:)
    authentication_token = AuthenticationToken.find_by(token: token)
    raise 'Token not found or already used' if authentication_token.nil? || authentication_token.used
    raise 'Token has expired' if authentication_token.expires_at < Time.current

    PasswordPolicyValidator.new.validate(password)
    encrypted_password = PasswordEncryptor.encrypt(password)

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
    encrypted_password = PasswordEncryptor.encrypt(password)

    user = User.find_by(id: user_id)
    raise 'User not found' if user.nil?

    user.update!(password: encrypted_password)

    'Password has been set successfully'
  rescue ActiveRecord::RecordInvalid => e
    raise e.message
  end
end
