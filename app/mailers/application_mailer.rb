# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include Constants

  default from: DEFAULT_EMAIL
  layout LAYOUT_MAILER

  def mailer
    mail to: params[:email], subject: RESET_PASSWORD
  end
end
