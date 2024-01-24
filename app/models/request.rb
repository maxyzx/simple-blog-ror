class Request < ApplicationRecord
  belongs_to :user

  validates :area, presence: true
  validates :menu, presence: true
  validates :hair_concerns, presence: true
  validates :images, presence: true
  validates :status, presence: true
  validates :user_id, presence: true

  validate :validate_images

  private

  def validate_images
    return if images.blank?
    errors.add(:images, 'cannot contain more than three files') if images.length > 3
    images.each do |image|
      errors.add(:images, 'each file must be less than 5MB') if image.size > 5.megabytes
      unless %w[image/png image/jpg image/jpeg].include?(image.content_type)
        errors.add(:images, 'must be in the allowed formats (png, jpg, jpeg)')
      end
    end
  end
end
