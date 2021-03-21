class ApplicationMailer < ActionMailer::Base
  default from: 'peledanyel@gmail.com'
  layout 'mailer'

  def mailer
    mail to: params[:email], subject: 'Resetare parola'
  end
end
