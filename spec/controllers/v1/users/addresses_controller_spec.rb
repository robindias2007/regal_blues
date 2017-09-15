# frozen_string_literal: true

describe V1::Users::AddressesController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }

    it 'returns http created if valid params are passed' do
      request.headers.merge! headers(user)
      post :create, params: valid_address_params
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

  describe 'GET #index' do
    let(:user) { create :user }
    let!(:address) { create :address, user: user }
    let(:another_address) { create :address }

    it 'returns a list of addresses of a particular user' do
      request.headers.merge! headers(user)
      get :index
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      request.headers.merge! headers(user)
      get :index
      expect(response.body).to include address.country
    end

    it 'does not list requests of other users' do
      request.headers.merge! headers(user)
      get :index
      expect(response.body).not_to include another_address.country
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
