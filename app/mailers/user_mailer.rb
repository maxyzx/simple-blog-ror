class UserMailer < ApplicationMailer
  def registration_confirmation(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Registration Confirmation')
  end
end

