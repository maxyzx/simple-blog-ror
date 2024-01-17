class EmailValidator
  # Define a regular expression for email validation
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validates the format of the given email
  def self.validate_email_format(email)
    email.match?(EMAIL_REGEX)
  end
end
