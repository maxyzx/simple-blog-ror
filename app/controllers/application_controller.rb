
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def create_request(params)
    # Perform the validations as per steps 1 and 2
    # ...

    # Step 3: Check if the email is already associated with an existing user
    user = User.find_by(email: params[:email])
    return { error: 'Account already exists.' } if user.present?

    # Steps 5 and 6: Validate images and create the request
    request = Request.new(params)
    if request.valid?
      request.save
    else
      return { error: request.errors.full_messages }
    end

    # Step 7: Send an email with the account creation link
    # Assuming token generation and email sending are handled here
    ApplicationMailer.send_account_creation_email(params[:email], 'your_token_here').deliver_now

    # Step 8: Return the success message
    { success: 'Request has been sent. Please check your email for the account creation link.' }
  end

end
