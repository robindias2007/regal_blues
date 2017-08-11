# frozen_string_literal: true

describe RegistrationsMailer, type: :mailer do
  describe 'confirmation' do
    let(:mail) { RegistrationsMailer.confirmation }

    it 'renders the headers'
    it 'renders the body'
  end
end
