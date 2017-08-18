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
      request.headers.merge! headers(designer)
      post :update_password, params:  { password: Faker::Internet.password(10, 20) }
      expect(response).to have_http_status 200
    end

    it 'returns http bad request if params are not valid' do
      request.headers.merge! headers(designer)
      post :update_password, params:  { password: 'asd' }
      expect(response).to have_http_status 400
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

  describe 'POST #update_mobile_number' do
    let!(:designer) { create :designer }

    it 'returns http success if designer exists' do
      request.headers.merge! headers(designer)
      post :update_mobile_number, params:  { mobile_number: ('+' + [1, 49, 91].sample.to_s + Faker::Number.number(10)) }
      expect(response).to have_http_status 200
    end

    it 'returns http bad request if params are not valid' do
      request.headers.merge! headers(designer)
      post :update_password, params:  { mobile_number: 'asd' }
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if authorization header does not exists' do
      post :update_mobile_number, params:  { mobile_number: ('+' + [1, 49, 91].sample.to_s + Faker::Number.number(10)) }
      expect(response).to have_http_status 401
    end

    it 'returns http not found if current designer does not exists' do
      jwt = Auth.issue(designer: 100_000)
      headers = { Authorization: "Bearer #{jwt}" }
      request.headers.merge! headers
      post :update_mobile_number, params:  { mobile_number: ('+' + [1, 49, 91].sample.to_s + Faker::Number.number(10)) }
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

  describe 'POST #update_store_info' do
    let(:designer) { create :designer }

    before do
      request.headers.merge! headers(designer)
    end

    it 'returns http created if designer exists and valid store params are passed' do
      post :update_store_info, params: valid_store_info_params
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      post :update_finance_info, params: invalid_store_info_params
      expect(response).to have_http_status 400
    end
  end

  describe 'POST #update_finance_info' do
    let(:designer) { create :designer }

    before do
      request.headers.merge! headers(designer)
    end

    it 'returns http created if designer exists and valid finance params are passed' do
      post :update_finance_info, params: valid_finance_info_params
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      post :update_finance_info, params: invalid_finance_info_params
      expect(response).to have_http_status 400
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

  def valid_store_info_params
    info = build :designer_store_info
    {
      data: {
        display_name:    info.display_name,
        registered_name: info.registered_name,
        pincode:         info.pincode,
        country:         info.country,
        state:           info.state,
        city:            info.city,
        address_line_1:  info.address_line_1,
        contact_number:  info.contact_number,
        min_order_price: info.min_order_price,
        processing_time: info.processing_time
      }
    }
  end

  def invalid_store_info_params
    info = build :designer_store_info
    {
      data: {
        display_name:    info.display_name,
        registered_name: info.registered_name,
        pincode:         info.pincode,
        country:         info.country,
        state:           info.state,
        city:            info.city
      }
    }
  end

  def valid_finance_info_params
    info = build :designer_finance_info
    {
      data: {
        bank_name:                 info.bank_name,
        ifsc_code:                 info.ifsc_code,
        bank_branch:               info.bank_branch,
        account_number:            info.account_number,
        personal_pan_number:       info.personal_pan_number,
        business_pan_number:       info.business_pan_number,
        tin_number:                info.tin_number,
        gstin_number:              info.gstin_number,
        blank_cheque_proof:        info.blank_cheque_proof,
        personal_pan_number_proof: info.personal_pan_number_proof,
        business_pan_number_proof: info.business_pan_number_proof,
        tin_number_proof:          info.tin_number_proof,
        gstin_number_proof:        info.gstin_number_proof,
        business_address_proof:    info.business_address_proof
      }
    }
  end

  def invalid_finance_info_params
    info = build :designer_finance_info
    {
      data: {
        bank_name:           info.bank_name,
        ifsc_code:           info.ifsc_code,
        bank_branch:         info.bank_branch,
        account_number:      info.account_number,
        personal_pan_number: info.personal_pan_number
      }
    }
  end
end
