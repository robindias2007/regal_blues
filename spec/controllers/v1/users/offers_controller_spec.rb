# frozen_string_literal: true

describe V1::Users::OffersController, type: :controller do
  let(:user) { create :user }
  let(:request_item) { create :request, user: user }
  let(:particular_request_item) { create :request, user: user }
  let(:offer) { create :offer, request: request_item }
  let(:another_offer) { create :offer }
  let(:particular_offer) { create :offer, request: particular_request_item }

  describe 'GET #index' do
    it 'returns a list of offers of a particular user' do
      request.headers.merge! headers(user)
      get :index
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      _ = offer
      request.headers.merge! headers(user)
      get :index
      expect(response.body).to include offer.id
    end

    it 'returns a list of offers for a particular user and a request' do
      _ = particular_offer
      request.headers.merge! headers(user)
      get :index, params: { request_id: particular_request_item.id }
      expect(response.body).to include particular_offer.id
    end

    it 'does not list offers of other users' do
      _ = another_offer
      request.headers.merge! headers(user)
      get :index
      expect(response.body).not_to include another_offer.id
    end
  end

  describe 'GET #show' do
    it 'returns the show page of that particular request' do
      _ = offer
      request.headers.merge! headers(user)
      get :show, params: { id: offer.id }
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      _ = offer
      request.headers.merge! headers(user)
      get :show, params: { id: offer.id }
      expect(response.body).to include offer.id
    end

    it 'does not show the offers of other users' do
      _ = another_offer
      request.headers.merge! headers(user)
      get :show, params: { id: another_offer.id }
      expect(response.body).not_to include another_offer.id
    end
  end

  private

  def headers(user)
    jwt = Auth.issue(resource: user.id)
    { Authorization: "Bearer #{jwt}" }
  end
end
