class User < ApplicationRecord
  # Existing associations and validations

  # Class method to check if a user exists with a given user_id
  def self.exists_with_id?(user_id)
    exists?(user_id)
  end

  def update_password(user_id, new_password)
    user = User.find_by(id: user_id)
    raise ActiveRecord::RecordNotFound, "User not found" unless user

    PasswordPolicyValidator.validate_password_policy(new_password)
    encrypted_password = PasswordEncryptor.encrypt_password(new_password)

    user.update!(password: encrypted_password)
  end
end
