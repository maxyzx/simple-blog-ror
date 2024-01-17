class User < ApplicationRecord
  # Associations
  # Here you would define relationships to other models if they exist.
  # For example: has_many :posts, dependent: :destroy

  # Validations
  validates :name, presence: true
end
