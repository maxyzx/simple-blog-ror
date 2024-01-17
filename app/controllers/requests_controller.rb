class RequestsController < ApplicationController
  include RequestParams
  include ImageValidator # Include the new module for image validation
  before_action :validate_user, only: [:send_to_hairstylist]
  before_action :validate_request, only: [:send_to_hairstylist, :send] # Keep the new action :send
  before_action :validate_create_params, only: [:create] # New before_action for create

  def create
    request = Request.new(request_params)
    request.status = 'pending' # Set default status to 'pending' from new code

    if request.save
      # Merged response format from new and existing code
      render json: { status: 201, request_id: request.id, request: request.as_json, status: 'created' }, status: :created
    else
      render json: { errors: request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def send_to_hairstylist
    # ... existing code ...
    # No changes needed here as there is no conflict
  end

  def send
    # ... existing code ...
    # No changes needed here as there is no conflict
  end

  private

  def request_params
    # Merged the two versions of request_params
    params.require(:request).permit(:area, :gender, :birth_date, :date_of_birth, :display_name, :menu, :hair_concerns, images: [])
  end

  def validate_create_params
    # New method from new code
    validator = ImageValidator.new
    request_params[:images].each { |image| validator.validate_each(request, :images, image) }
    render json: { errors: 'Area is mandatory' }, status: :bad_request if params[:area].blank?
    render json: { errors: 'Gender must be Male, Female, or Do Not Answer' }, status: :bad_request unless ['Male', 'Female', 'Do Not Answer'].include?(params[:gender])
    render json: { errors: 'Birth date is mandatory and must be a valid date' }, status: :bad_request if params[:birth_date].blank? || !Date.parse(params[:birth_date]) rescue nil
    render json: { errors: 'Display name is mandatory and must not exceed 20 characters' }, status: :bad_request if params[:display_name].blank? || params[:display_name].length > 20
    render json: { errors: 'Menu is mandatory' }, status: :bad_request if params[:menu].blank?
    render json: { errors: 'Hair concerns must not exceed 2000 characters' }, status: :bad_request if params[:hair_concerns] && params[:hair_concerns].length > 2000
  end

  def validate_user
    # ... existing code ...
    # No changes needed here as there is no conflict
  end

  def validate_request
    # ... existing code ...
    # No changes needed here as there is no conflict
  end
end
