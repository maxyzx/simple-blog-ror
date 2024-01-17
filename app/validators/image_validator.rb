# frozen_string_literal: true

class ImageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.send(attribute).attached?

    record.send(attribute).each do |image|
      unless image.blob.content_type.in?(%w[image/png image/jpg image/jpeg])
        record.errors.add(attribute, 'must be a PNG, JPG, or JPEG file')
      end

      if image.blob.byte_size > 5.megabytes
        record.errors.add(attribute, 'size must be less than 5MB')
      end
    end
  end
end
