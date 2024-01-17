
class RequestsController < ApplicationController
  before_action :validate_user, only: [:send_to_hairstylist]
  before_action :validate_request, only: [:send_to_hairstylist]

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

  private
  
  def validate_user
    render json: { error: 'User not found' }, status: :not_found unless User.exists_with_id?(params[:user_id])
  end

  def validate_request
    render json: { error: 'Request not found' }, status: :not_found unless Request.exists_with_id?(params[:request_id])
  end
end
