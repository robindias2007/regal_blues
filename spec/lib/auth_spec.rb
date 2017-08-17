# frozen_string_literal: true

describe Auth do
  let(:user) { create :user }
  let(:payload) { { id: user.id, iat: Time.now.getlocal } }
  let(:token) { described_class.issue(payload) }

  context '.issue' do
    it 'issues valid token' do
      jwt_token = JWT.encode(payload, described_class.rsa_private, described_class::ALGORITHM)
      expect(jwt_token).to eq token
    end
  end

  context '.decode' do
    it 'properly decodes the token' do
      decoded_value = JWT.decode(token, described_class.rsa_public, true, algorithm: described_class::ALGORITHM).first
      expect(decoded_value).to eq described_class.decode(token)
    end

    it 'raises error if valid jwt token is not sent' do
      expect do
        JWT.decode('token.token.token', described_class.rsa_public, true,
          algorithm: described_class::ALGORITHM).first
      end.to raise_error(JWT::DecodeError)
    end
  end
end
