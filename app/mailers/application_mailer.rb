# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include Constants

  default from: DEFAULT_EMAIL
  layout LAYOUT_MAILER

  def mailer
    mail to: params[:email], subject: I18n.t('mailer.reset_password')
  end
end
