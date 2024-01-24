
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_account_creation_email(email, token)
    @token = token
    mail(to: email, subject: 'Complete your account setup')
  end

end
