# frozen_string_literal: true

describe V1::Users::RegistrationsController, type: :controller do
  describe 'GET #confirm' do
    let(:user) { create :user }

    it 'returns http success if token is valid' do
      get :confirm, params: { token: user.confirmation_token }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if token is invalid or if user is not found' do
      get :confirm, params: { token: SecureRandom.hex(10) }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #create' do
    let(:visitor) { build :user }

    it 'returns http success if valid params are passed' do
      post :create, params: valid_user_params(visitor)
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      post :create, params: invalid_user_params(visitor)
      expect(response).to have_http_status 400
    end
  end

  describe 'POST #resend_confirmation' do
    let(:user) { create :user }

    it 'returns http success if user exists' do
      post :resend_confirmation, params: { email: user.email }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if user does not exists' do
      post :resend_confirmation, params: { email: Faker::Internet.email }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #send_reset_password_instructions' do
    let(:user) { create :user }

    it 'returns http success if user exists' do
      post :send_reset_password_instructions, params: { login: user.email }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if user does not exists' do
      post :send_reset_password_instructions, params: { login: Faker::Internet.email }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #reset_password' do
    it 'returns http success if user exists' do
      token = SecureRandom.hex(10)
      create :user, reset_password_token: token, reset_password_token_sent_at: DateTime.now.getlocal
      get :reset_password, params: { token: token }
      expect(response).to have_http_status 200
    end

    it 'returns http resource not found if user does not exists' do
      get :reset_password, params: { token: SecureRandom.hex(10) }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #update_password' do
    let!(:user) { create :user }

    it 'returns http success if user exists' do
      request.headers.merge! headers(user)
      post :update_password, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 200
    end

    it 'returns http bad request if params are not valid' do
      request.headers.merge! headers(user)
      post :update_password, params:  { password: 'asd' }
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if authorization header does not exists' do
      post :update_password, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current user does not exists' do
      jwt = Auth.issue(user: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      post :update_password, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #update_mobile_number' do
    let!(:user) { create :user }

    it 'returns http success if user exists' do
      request.headers.merge! headers(user)
      post :update_mobile_number, params:  { mobile_number: ('+' + [1, 49, 91].sample.to_s + Faker::Number.number(10)) }
      expect(response).to have_http_status 200
    end

    it 'returns http bad request if params are not valid' do
      request.headers.merge! headers(user)
      post :update_mobile_number, params:  { mobile_number: 'asd' }
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if authorization header does not exists' do
      post :update_mobile_number, params:  { mobile_number: ('+' + [1, 49, 91].sample.to_s + Faker::Number.number(10)) }
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current user does not exists' do
      jwt = Auth.issue(user: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      post :update_mobile_number, params:  { mobile_number: ('+' + [1, 49, 91].sample.to_s + Faker::Number.number(10)) }
      expect(response).to have_http_status 404
    end
  end

  describe 'GET #resend_otp' do
    let!(:user) { create :user }

    it 'returns http success if user exists' do
      request.headers.merge! headers(user)
      get :resend_otp
      expect(response).to have_http_status 200
    end

    it 'returns http unauthorized if authorization header does not exists' do
      get :resend_otp
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current user does not exists' do
      jwt = Auth.issue(user: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      get :resend_otp
      expect(response).to have_http_status 404
    end
  end

  describe 'POST #verify_otp' do
    let(:user) { create :user }

    it 'returns http success if user exists and OTP is valid' do
      Redis.current.set(user.id, '123456')
      request.headers.merge! headers(user)
      post :verify_otp, params:  { otp: Redis.current.get(user.id) }
      expect(response).to have_http_status 200
    end

    it 'returns http bad request if user exists and OTP is invalid' do
      Redis.current.set(user.id, '123456')
      request.headers.merge! headers(user)
      post :verify_otp, params:  { otp: '654321' }
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if authorization header does not exists' do
      post :verify_otp, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current user does not exists' do
      jwt = Auth.issue(user: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      post :verify_otp, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 404
    end
  end

  private

  def valid_user_params(user)
    {
      email:         user.email,
      password:      user.password,
      username:      user.username,
      mobile_number: user.mobile_number,
      gender:        user.gender,
      full_name:     user.full_name
    }
  end

  def invalid_user_params(user)
    {
      email:    user.email,
      password: user.password,
      username: user.username
    }
  end

  def headers(user)
    jwt = Auth.issue(resource: user.id)
    { Authorization: "Bearer #{jwt}" }
  end
end
