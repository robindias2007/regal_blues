# frozen_string_literal: true

describe V1::Users::RequestsController, type: :controller do
  describe 'POST #create' do
    let!(:user) { create :user }

    it 'returns http created if valid params are passed' do
      request.headers.merge! headers(user)
      post :create, params: valid_request_params
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      request.headers.merge! headers(user)
      post :create, params: invalid_request_params
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if user is not present' do
      post :create, params: invalid_request_params
      expect(response).to have_http_status 401
    end
  end

  describe 'GET #index' do
    let(:user) { create :user }
    let!(:request_item) { create :request, user: user }
    let(:another_request_item) { create :request }

    it 'returns a list of requests of a particular user' do
      request.headers.merge! headers(user)
      get :index
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      request.headers.merge! headers(user)
      get :index
      expect(response.body).to include request_item.name
    end

    it 'does not list requests of other users' do
      request.headers.merge! headers(user)
      get :index
      expect(response.body).not_to include another_request_item.name
    end
  end

  private

  def headers(user)
    jwt = Auth.issue(resource: user.id)
    { Authorization: "Bearer #{jwt}" }
  end

  def valid_request_params
    min = Faker::Commerce.price
    sc = create :sub_category
    {
      request: {
        name:            Faker::Commerce.product_name,
        size:            %w[xs-s s-m m-l l-xl xl-xxl].sample,
        min_budget:      min,
        max_budget:      min + 100,
        timeline:        Faker::Number.between(1, 10),
        description:     Faker::Lorem.paragraph,
        sub_category_id: sc.id
      }
    }
  end

  def invalid_request_params
    min = Faker::Commerce.price
    {
      request: {
        name:       Faker::Commerce.product_name,
        size:       %w[xs-s s-m m-l l-xl xl-xxl].sample,
        min_budget: min,
        max_budget: min + 100
      }
    }
  end
end
