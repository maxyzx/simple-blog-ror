class Request < ApplicationRecord
  has_many_attached :images
  validates_length_of :images, maximum: 3
  validate :check_images

  # Check if a request exists with a given request_id
  def self.exists_with_id?(request_id)
    exists?(request_id)
  end

  # Assign request to a user and set status
  def assign_to_user_and_set_status(user_id)
    update(user_id: user_id, status: 'assigned')
  end

  private

  def check_images
    images.each { |image| errors.add(:images, 'must be less than 5MB') if image.blob.byte_size > 5.megabytes }
    images.each { |image| errors.add(:images, 'must be a JPEG or PNG') unless ['image/jpeg', 'image/png'].include?(image.blob.content_type) }
  end
end
