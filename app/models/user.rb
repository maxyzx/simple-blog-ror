
class User < ApplicationRecord
  # Relationships
  has_many :requests, dependent: :destroy
  has_many :privacy_policy_agreements, dependent: :destroy
  has_many :terms_of_use_agreements, dependent: :destroy
  has_one :authentication_token, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :display_name, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
  validates :is_customer, inclusion: { in: [true, false] }
end
