class Request < ApplicationRecord
  belongs_to :user

  validates :area, presence: true
  validates :menu, presence: true
  validates :hair_concerns, presence: true
  validates :images, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
end
