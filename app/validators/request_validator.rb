class RequestValidator
  include ActiveModel::Model

  attr_accessor :area, :gender, :date_of_birth, :display_name, :menu, :hair_concerns, :images

  validate :validate_area
  validate :validate_gender
  validate :validate_date_of_birth
  validate :validate_display_name
  validate :validate_menu
  validate :validate_hair_concerns
  validate :validate_images

  def validate_area
    errors.add(:area, 'cannot be blank') if area.blank?
  end

  def validate_gender
    # Assuming gender enum is defined in User model
    errors.add(:gender, 'is not a valid gender') unless User.genders.keys.include?(gender)
  end

  def validate_date_of_birth
    Date.parse(date_of_birth)
  rescue ArgumentError
    errors.add(:date_of_birth, 'is not a valid date')
  end

  def validate_display_name
    errors.add(:display_name, 'cannot exceed 20 characters') if display_name.length > 20
  end

  def validate_menu
    # Assuming menu options are defined somewhere
    errors.add(:menu, 'is not a valid option') unless ['Option1', 'Option2', 'Option3'].include?(menu)
  end

  def validate_hair_concerns
    errors.add(:hair_concerns, 'cannot exceed 2000 characters') if hair_concerns.length > 2000
  end

  def validate_images
    errors.add(:images, 'cannot contain more than three files') if images.length > 3
    images.each do |image|
      errors.add(:images, 'each file must be less than 5MB') if image.size > 5.megabytes
      unless %w[image/png image/jpg image/jpeg].include?(image.content_type)
        errors.add(:images, 'must be in the allowed formats (png, jpg, jpeg)')
      end
    end
  end
end
