class RequestsController < ApplicationController
  def create
    request_creation_service = RequestCreationService.new
    result = request_creation_service.create_request(request_params)

    if result[:errors].blank?
      render json: { id: result[:id], status: result[:status] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def request_params
    params.permit(:area, :menu, :hair_concerns, images: [])
  end
end
