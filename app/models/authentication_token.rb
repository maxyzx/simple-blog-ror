class AuthenticationToken < ApplicationRecord
  # Relationships
  belongs_to :user

  # Validations
  validates :token, presence: true
  validates :expires_at, presence: true
  validates :used, inclusion: { in: [true, false] }
end
