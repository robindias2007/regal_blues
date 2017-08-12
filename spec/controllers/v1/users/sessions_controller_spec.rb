# frozen_string_literal: true

describe V1::Users::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }

    it 'returns a http success if valid params are passed' do
      post :create, params: { email: user.email, password: user.password }
      expect(response).to have_http_status 200
    end

    it 'returns a valid jwt if valid params are passed' do
      post :create, params: { email: user.email, password: user.password }
      returned = JSON.parse(response.body)
      expect(returned).to include 'jwt'
    end
  end
end
