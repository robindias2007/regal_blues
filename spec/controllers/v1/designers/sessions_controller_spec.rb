# frozen_string_literal: true

describe V1::Designers::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:designer) { create :designer }

    it 'returns a http success if valid params are passed' do
      post :create, params: { login: designer.email, password: designer.password }
      expect(response).to have_http_status 200
    end

    it 'returns a valid jwt if valid email is passed' do
      post :create, params: { login: designer.email, password: designer.password }
      returned = JSON.parse(response.body)
      expect(returned).to include 'jwt'
    end

    it 'returns a http Unauthorized if invalid params are passed' do
      post :create, params: { login: designer.email, password: 'password' }
      expect(response).to have_http_status 401
    end

    it 'does not return a jwt if invalid params are passed' do
      post :create, params: { login: designer.email, password: 'password' }
      returned = JSON.parse(response.body)
      expect(returned).not_to include 'jwt'
    end
  end
end
