class PasswordValidator
  # This method is now a class method, as per the new code.
  def self.validate_password_policy(password, email)
    return false if password.length < 6
    return false if password == email
    return false unless password.match?(/\A(?=.*[a-zA-Z])(?=.*[0-9]).*\z/)

    true
  end
end
