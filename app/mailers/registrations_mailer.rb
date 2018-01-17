# frozen_string_literal: true

class RegistrationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.registrations_mailer.confirmation.subject
  #
  def confirmation(user)
    @user = user
    @path = "#{ENV['USER_APPLICATION_URL']}#{user.class.name.downcase.pluralize}"
    @token = user.confirmation_token
    # mail to: user.email, subject: 'Thank you for signing up. Please confirm to continue! | Regal Blues'
    mail to: user.email, subject: 'Email verification pending'
  end

  def password(user)
    @user = user
    @path = "#{ENV['USER_APPLICATION_URL']}#{user.class.name.downcase.pluralize}"
    @token = user.reset_password_token
    # mail to: user.email, subject: 'Password reset instructions | Regal Blues'
    mail to: user.email, subject: 'Reset your Password'
  end
end
