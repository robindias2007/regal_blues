# frozen_string_literal: true

describe Auth do
  let(:auth) { described_class }
  let(:user) { create :user }
  let(:payload) { { id: user.id, iat: Time.now.getlocal } }
  let(:token) { described_class.issue(payload) }

  context '.issue' do
    it 'issues valid token' do
      jwt_token = JWT.encode(payload, auth.rsa_private, auth::ALGORITHM)
      expect(jwt_token).to eq token
    end
  end

  context '.decode' do
    it 'properly decodes the token' do
      decoded_value = JWT.decode(token, auth.rsa_public, true, algorithm: auth::ALGORITHM).first
      expect(decoded_value).to eq auth.decode(token)
    end

    it 'raises error if valid jwt token is not sent' do
      expect do
        JWT.decode('token.token.token', auth.rsa_public, true,
          algorithm: auth::ALGORITHM).first
      end.to raise_error(JWT::DecodeError)
    end
  end
end
