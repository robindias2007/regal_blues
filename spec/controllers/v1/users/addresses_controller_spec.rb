# frozen_string_literal: true

describe V1::Users::AddressesController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }

    it 'returns http created if valid params are passed' do
      request.headers.merge! headers(user)
      post :create, params: valid_address_params
      pp JSON.parse response.body
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      request.headers.merge! headers(user)
      post :create, params: invalid_address_params
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if user is not present' do
      post :create, params: invalid_address_params
      expect(response).to have_http_status 401
    end
  end

  private

  def headers(user)
    jwt = Auth.issue(resource: user.id)
    { Authorization: "Bearer #{jwt}" }
  end

  def valid_address_params
    { address: {
      country:        Faker::Address.country,
      pincode:        Faker::Address.zip,
      street_address: Faker::Address.secondary_address + Faker::Address.street_address,
      landmark:       Faker::Address.community,
      city:           Faker::Address.city,
      state:          Faker::Address.state,
      nickname:       %w[home work other].sample
      } }
  end

  def invalid_address_params
    { address: {
      country:        Faker::Address.country,
      pincode:        Faker::Address.zip,
      street_address: Faker::Address.secondary_address + Faker::Address.street_address
      } }
  end
end
