# frozen_string_literal: true

class RegistrationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.registrations_mailer.confirmation.subject
  #
  def confirmation(user)
    @token = user.confirmation_token
    mail to: user.email, subject: 'Thank you for signing up. Please confirm to continue! | Regal Blues'
  end
end
