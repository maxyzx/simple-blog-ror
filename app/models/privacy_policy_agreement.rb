class PrivacyPolicyAgreement < ApplicationRecord
  belongs_to :user

  validates :agreed_at, presence: true
end
