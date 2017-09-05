# frozen_string_literal: true

describe V1::Designers::RequestsController, type: :controller do
  let(:designer) { create :designer }
  let(:request_item) { create :request }
  let(:request_designer) { create :request_designer, designer: designer, request: request_item }
  let(:random_request_designer) { create :request_designer }

  describe 'GET #index' do
    it 'returns a list of requests of a particular designer' do
      request.headers.merge! headers(designer)
      get :index
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      _ = request_designer
      request.headers.merge! headers(designer)
      get :index
      expect(response.body).to include request_item.name
    end

    it 'does not list requests of other designers' do
      _ = random_request_designer
      request.headers.merge! headers(designer)
      get :index
      expect(response.body).not_to include random_request_designer.request.name
    end
  end

  describe 'GET #show' do
    it 'returns the show page of that particular request' do
      _ = request_designer
      request.headers.merge! headers(designer)
      get :show, params: { id: request_item.id }
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      _ = request_designer
      request.headers.merge! headers(designer)
      get :show, params: { id: request_item.id }
      expect(response.body).to include request_item.name
    end

    it 'does not show the requests of other designers' do
      _ = random_request_designer
      request.headers.merge! headers(designer)
      get :show, params: { id: random_request_designer.request.id }
      expect(response.body).not_to include random_request_designer.request.name
    end

    it 'returns 404 resource not found for the requests of other designers' do
      _ = random_request_designer
      request.headers.merge! headers(designer)
      get :show, params: { id: random_request_designer.request.id }
      expect(response).to have_http_status 404
    end
  end

  private

  def headers(designer)
    jwt = Auth.issue(resource: designer.id)
    { Authorization: "Bearer #{jwt}" }
  end
end
