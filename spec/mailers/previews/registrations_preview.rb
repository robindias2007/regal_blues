# Preview all emails at http://localhost:3000/rails/mailers/registrations
class RegistrationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/registrations/confirmation
  def confirmation
    RegistrationsMailer.confirmation
  end

end
