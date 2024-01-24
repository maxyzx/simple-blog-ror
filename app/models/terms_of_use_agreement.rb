class TermsOfUseAgreement < ApplicationRecord
  belongs_to :user

  validates :agreed_at, presence: true
end
