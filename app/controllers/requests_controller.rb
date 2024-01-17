class RequestsController < ApplicationController
  include RequestParams
  before_action :validate_user, only: [:send_to_hairstylist]
  before_action :validate_request, only: [:send_to_hairstylist, :send] # Added :send to the before_action for validate_request

  def create
    request = Request.new(request_params)
    request.status = 'new' # Set default status to 'new'

    if request.save
      render json: { request_id: request.id, status: 'created' }, status: :created
    else
      render json: { errors: request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def send_to_hairstylist
    user_id = params[:user_id]
    request_id = params[:request_id]

    if User.exists_with_id?(user_id) && Request.exists_with_id?(request_id)
      request = Request.find(request_id)
      request.assign_to_user_and_set_status(user_id)
      render json: { request: request, status: request.status }, status: :ok
    else
      render json: { error: 'User or Request not found' }, status: :not_found
    end
  end

  def send
    request_id = params[:request_id]

    if Request.exists_with_id?(request_id)
      request = Request.find(request_id)
      if request.user_id.present? # Check if the request is associated with a user
        request.assign_to_user_and_set_status(request.user_id)
        render json: { message: 'Request has been sent successfully.', status: 'assigned' }, status: :ok
      else
        render json: { error: 'Request is not associated with a user' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Request not found' }, status: :not_found
    end
  end

  private

  def request_params
    params.require(:request).permit(:area, :gender, :date_of_birth, :display_name, :menu, :hair_concerns, images: [])
  end

  def validate_user
    render json: { error: 'User not found' }, status: :not_found unless User.exists_with_id?(params[:user_id])
  end

  def validate_request
    request_id = params[:request_id]
    unless Request.exists_with_id?(request_id)
      render json: { error: 'Request not found' }, status: :not_found
    end
  end
end
