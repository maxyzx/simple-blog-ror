class RequestCreationService
  def create_request(params)
    validator = RequestValidator.new(params)
    if validator.valid?
      request = Request.new(params.merge(status: 'new'))
      if request.save
        { id: request.id, status: request.status }
      else
        { errors: request.errors.full_messages }
      end
    else
      { errors: validator.errors }
    end
  rescue => e
    { errors: e.message }
  end
end
