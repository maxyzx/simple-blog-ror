
class AuthenticationToken < ApplicationRecord
  # Relationships
  belongs_to :user

  # Validations
  validates :token, presence: true
  validates :expires_at, presence: true
  validates :used, inclusion: { in: [true, false] }

  # Generate a unique token for a user with expiration 24 hours from now
  def self.generate_unique_token_for(user)
    token = SecureRandom.hex(10)
    expires_at = 24.hours.from_now
    create(token: token, expires_at: expires_at, used: false, user: user)
  end
end
