# frozen_string_literal: true

describe V1::Designers::RegistrationsController, type: :controller do
  describe 'GET #confirm' do
    let(:designer) { create :designer }

    it 'returns http success if token is valid' do
      get :confirm, params: { token: designer.confirmation_token }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if token is invalid or if designer is not found' do
      get :confirm, params: { token: SecureRandom.hex(10) }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #create' do
    let(:visitor) { build :designer }

    it 'returns http success if valid params are passed' do
      post :create, params: valid_designer_params(visitor)
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      post :create, params: invalid_designer_params(visitor)
      expect(response).to have_http_status 400
    end
  end

  describe 'POST #resend_confirmation' do
    let(:designer) { create :designer }

    it 'returns http success if designer exists' do
      post :resend_confirmation, params: { email: designer.email }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if designer does not exists' do
      post :resend_confirmation, params: { email: Faker::Internet.email }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #send_reset_password_instructions' do
    let(:designer) { create :designer }

    it 'returns http success if designer exists' do
      post :send_reset_password_instructions, params: { login: designer.email }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if designer does not exists' do
      post :send_reset_password_instructions, params: { login: Faker::Internet.email }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #reset_password' do
    it 'returns http success if designer exists' do
      token = SecureRandom.hex(10)
      create :designer, reset_password_token: token, reset_password_token_sent_at: DateTime.now.getlocal
      get :reset_password, params: { token: token }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if designer does not exists' do
      get :reset_password, params: { token: SecureRandom.hex(10) }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #update_password' do
    let!(:designer) { create :designer }

    it 'returns http success if designer exists' do
      jwt = Auth.issue(designer: designer.id)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      post :update_password, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 200
    end

    it 'returns http unauthorized if authorization header does not exists' do
      post :update_password, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current designer does not exists' do
      jwt = Auth.issue(designer: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      post :update_password, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 404
    end
  end

  describe 'GET #resend_otp' do
    let!(:designer) { create :designer }

    it 'returns http success if designer exists' do
      request.headers.merge! headers(designer)
      get :resend_otp
      expect(response).to have_http_status 200
    end

    it 'returns http unauthorized if authorization header does not exists' do
      get :resend_otp
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current designer does not exists' do
      jwt = Auth.issue(designer: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      get :resend_otp
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #verify_otp' do
    let(:designer) { create :designer }

    it 'returns http success if designer exists and OTP is valid' do
      Redis.current.set(designer.id, '123456')
      request.headers.merge! headers(designer)
      post :verify_otp, params:  { otp: Redis.current.get(designer.id) }
      expect(response).to have_http_status 200
    end

    it 'returns http bad request if designer exists and OTP is invalid' do
      Redis.current.set(designer.id, '123456')
      request.headers.merge! headers(designer)
      post :verify_otp, params:  { otp: '654321' }
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if authorization header does not exists' do
      post :verify_otp, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current designer does not exists' do
      jwt = Auth.issue(designer: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      post :verify_otp, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 404
    end
  end

  private

  def valid_designer_params(designer)
    {
      email:         designer.email,
      password:      designer.password,
      mobile_number: designer.mobile_number,
      full_name:     designer.full_name,
      location:      designer.location
    }
  end

  def invalid_designer_params(designer)
    {
      email:    designer.email,
      password: designer.password
    }
  end

  def headers(designer)
    jwt = Auth.issue(designer: designer.id)
    { Authorization: "Bearer #{jwt}" }
  end
end
