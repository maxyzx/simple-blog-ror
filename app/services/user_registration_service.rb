class UserRegistrationService
  VALID_GENDERS = ['Male', 'Female', 'Do Not Answer'].freeze

  def self.register_user(attributes)
    email = attributes[:email]
    password = attributes[:password]
    display_name = attributes[:display_name]
    date_of_birth = attributes[:date_of_birth]
    gender = attributes[:gender]

    return { error: 'Invalid email format', status: 422 } unless EmailValidator.validate_email_format(email)
    return { error: 'Email already registered', status: 409 } if User.email_exists?(email)
    return { error: 'Invalid password policy', status: 422 } unless PasswordValidator.validate_password_policy(password, email)
    return { error: 'Display name is mandatory and must not exceed 20 characters', status: 400 } if display_name.nil? || display_name.length > 20
    return { error: 'Date of birth is mandatory and must be a valid date', status: 400 } unless date_of_birth.is_a?(Date)
    return { error: 'Invalid gender', status: 400 } unless VALID_GENDERS.include?(gender)

    user = User.create_with_encrypted_password(attributes)
    token = PasswordResetToken.create_email_verification_token(user.id)
    UserMailer.send_verification_email(user, token)
    UserAgreement.create_user_agreement(user.id)

    {
      status: 201,
      user: {
        id: user.id,
        email: user.email,
        display_name: user.display_name,
        date_of_birth: user.date_of_birth,
        gender: user.gender,
        status: user.status
      }
    }
  rescue StandardError => e
    { error: e.message, status: 500 }
  end
end
