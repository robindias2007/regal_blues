# frozen_string_literal: true

require 'active_model_serializers'
describe V1::Designers::ProductsController, type: :controller do
  describe 'POST #create' do
    let(:designer) { create :designer }

    it 'returns http created if valid params are passed' do
      request.headers.merge! headers(designer)
      post :create, params: valid_product_params
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      request.headers.merge! headers(designer)
      post :create, params: invalid_product_params
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if designer is not present' do
      post :create, params: valid_product_params
      expect(response).to have_http_status 401
    end
  end

  describe 'GET #index' do
    let(:designer) { create :designer }
    let(:product_item) { create :product, designer: designer }
    let!(:product_info) { create :product_info, product: product_item }
    let(:another_product_item) { create :product }

    it 'returns a list of requests of a particular designer' do
      request.headers.merge! headers(designer)
      get :index
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      request.headers.merge! headers(designer)
      get :index
      expect(response.body).to include product_item.name
    end

    it 'does not list requests of other designers' do
      request.headers.merge! headers(designer)
      get :index
      expect(response.body).not_to include another_product_item.name
    end
  end

  describe 'GET #show' do
    let(:designer) { create :designer }
    let(:product_item) { create :product, designer: designer }
    let!(:product_info) { create :product_info, product: product_item }
    let(:another_product_item) { create :product }

    it 'returns the show page of that particular request' do
      request.headers.merge! headers(designer)
      get :show, params: { id: product_item.id }
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      request.headers.merge! headers(designer)
      get :show, params: { id: product_item.id }
      expect(response.body).to include product_item.name
    end

    it 'does not show the requests of other designers' do
      request.headers.merge! headers(designer)
      get :show, params: { id: another_product_item.id }
      expect(response.body).not_to include another_product_item.name
    end
  end

  describe 'PATCH #toggle_active' do
    let(:designer) { create :designer }
    let(:product_item) { create :product, designer: designer }

    it 'returns http success code when the params are correct' do
      request.headers.merge! headers(designer)
      patch :toggle_active, params: { id: product_item.id }
      expect(response).to have_http_status 200
    end
  end

  private

  def headers(designer)
    jwt = Auth.issue(resource: designer.id)
    { Authorization: "Bearer #{jwt}" }
  end

  def valid_product_params
    sc = create :sub_category
    { product: {
        name:                    Faker::Commerce.product_name,
        description:             Faker::Lorem.paragraph,
        selling_price:           Faker::Commerce.price + 100_000,
        sub_category_id:         sc.id,
        product_info_attributes: [{ color: Faker::Color.color_name,
          fabric: 'lorem', care: 'lorem', notes: 'lorem', work: 'lorem' }],
        images_attributes:       [{ image: image_data, width: 10, height: 10 }]
      } }
  end

  def invalid_product_params
    { product: {
        name:                    Faker::Commerce.product_name,
        description:             Faker::Lorem.paragraph,
        images_attributes:       [image: 'asd', width: 10, height: 10],
        product_info_attributes: [fabric: 'lorem', care: 'lorem', notes: 'lorem', work: 'lorem']
      } }
  end

  def image_data
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAnElEQVR42u3RAQ0AAAgDIN8'\
  '/9K3hHFQg03Y4I0KEIEQIQoQgRAhChAgRghAhCBGCECEIEYIQhAhBiBCECEGIEIQgRAhChCBECEKEIAQhQhAiBCFCECIEIQgRghA'\
  'hCBGCECEIQYgQhAhBiBCECEEIQoQgRAhChCBECEIQIgQhQhAiBCFCEIIQIQgRghAhCBGCECFChCBECEKEIOS7BchtK0ieNE3rAAAAAElFTkSuQmCC'
  end
end
