class Api::V1::RequestsController < ApplicationController
  include RequestParams

  # POST /api/v1/requests
  def create
    begin
      validate_request_params!(request_params)
      request = Request.new(request_params)
      if request.save
        render json: { status: 201, request: request.as_json.merge(status: 'pending') }, status: :created
      else
        render json: { errors: request.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing, ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def request_params
    params.require(:request).permit(:area, :gender, :birth_date, :display_name, :menu, images: [], :hair_concerns).merge(user_id: current_user.id)
  end

  def validate_request_params!(params)
    validate_area!(params[:area])
    validate_gender!(params[:gender])
    validate_birth_date!(params[:birth_date])
    validate_display_name!(params[:display_name])
    validate_menu!(params[:menu])
    validate_images!(params[:images])
    validate_hair_concerns!(params[:hair_concerns])
  end

  def validate_area!(area)
    raise ArgumentError, 'Area is a mandatory field.' if area.blank?
  end

  def validate_gender!(gender)
    valid_genders = ['Male', 'Female', 'Do Not Answer']
    raise ArgumentError, 'Gender must be one of "Male", "Female", "Do Not Answer".' unless valid_genders.include?(gender)
  end

  def validate_birth_date!(birth_date)
    raise ArgumentError, 'Birth date is a mandatory field and must be a valid date.' if birth_date.blank? || !birth_date.match(/\d{4}-\d{2}-\d{2}/)
  end

  def validate_display_name!(display_name)
    raise ArgumentError, 'Display name is a mandatory field and must not exceed 20 characters.' if display_name.blank? || display_name.length > 20
  end

  def validate_menu!(menu)
    raise ArgumentError, 'Menu is a mandatory field.' if menu.blank?
  end

  def validate_images!(images)
    raise ArgumentError, 'Images must be in png, jpg, jpeg format and not exceed 5MB in size. Up to three images can be uploaded.' unless images.all? { |image| image.size <= 5.megabytes && %w(png jpg jpeg).include?(image.content_type.split('/').last) }
  end

  def validate_hair_concerns!(hair_concerns)
    raise ArgumentError, 'Hair concerns must not exceed 2000 characters.' if hair_concerns && hair_concerns.length > 2000
  end
end
