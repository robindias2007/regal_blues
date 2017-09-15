# frozen_string_literal: true

describe V1::Designers::OffersController, type: :controller do
  describe 'POST #create' do
    let(:designer) { create :designer }

    it 'returns http created if valid params are passed' do
      request.headers.merge! headers(designer)
      post :create, params: valid_offer_params
      expect(response).to have_http_status 201
    end

    it 'returns http bad request if invalid params are passed' do
      request.headers.merge! headers(designer)
      post :create, params: invalid_offer_params
      expect(response).to have_http_status 400
    end

    it 'returns http unauthorized if designer is not present' do
      post :create, params: valid_offer_params
      expect(response).to have_http_status 401
    end
  end

  describe 'GET #index' do
    let(:designer) { create :designer }
    let(:offer) { create :offer, designer: designer }
    let(:offer_quotation) { create :offer_quotation, offer: offer }
    let(:offer_quotation_gallery) { create :offer_quotation_gallery, offer_quotation: offer_quotation }
    let(:oqg_image) { create :image, imageable: offer_quotation_gallery }
    let(:offer_measurement) { create :offer_measurement, offer: offer }

    let(:another_offer) { create :offer, designer: create(:designer) }

    it 'returns a list of requests of a particular designer' do
      request.headers.merge! headers(designer)
      get :index
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      _filler = [oqg_image, offer_measurement, another_offer]
      request.headers.merge! headers(designer)
      get :index
      expect(response.body).to include offer.id
    end

    it 'does not list requests of other designers' do
      request.headers.merge! headers(designer)
      get :index
      expect(response.body).not_to include another_offer.id
    end
  end

  describe 'GET #show' do
    let(:designer) { create :designer }
    let(:offer) { create :offer, designer: designer }
    let(:offer_quotation) { create :offer_quotation, offer: offer }
    let(:offer_quotation_gallery) { create :offer_quotation_gallery, offer_quotation: offer_quotation }
    let(:oqg_image) { create :image, imageable: offer_quotation_gallery }
    let(:offer_measurement) { create :offer_measurement, offer: offer }

    let(:another_offer) { create :offer, designer: create(:designer) }

    it 'returns the show page of that particular request' do
      request.headers.merge! headers(designer)
      get :show, params: { id: offer.id }
      expect(response).to have_http_status 200
    end

    it 'matches the content' do
      request.headers.merge! headers(designer)
      get :show, params: { id: offer.id }
      expect(response.body).to include offer.id
    end

    it 'does not show the requests of other designers' do
      request.headers.merge! headers(designer)
      get :show, params: { id: another_offer.id }
      expect(response.body).not_to include another_offer.id
    end
  end

  private

  def headers(designer)
    jwt = Auth.issue(resource: designer.id)
    { Authorization: "Bearer #{jwt}" }
  end

  def valid_offer_params
    request = create :request
    {
      offer: {
        request_id: request.id, offer_quotations_attributes: [price: Faker::Commerce.price,
          description: Faker::Lorem.paragraph, offer_quotation_galleries_attributes:
          [name: Faker::Commerce.product_name, images_attributes: [image: image_data]]],
        offer_measurements_attributes: [data: {
          attributes: %w[neck shoulder waist]
          }]
      }
    }
  end

  def invalid_offer_params
    {
      offer: {
        offer_quotations_attributes: [price: Faker::Commerce.price, description: Faker::Lorem.paragraph,
          offer_quotation_galleries_attributes: [name: Faker::Commerce.product_name, images_attributes:
            [image: 'asd']]], offer_measurement_attributes: [data: {
          attributes: %w[neck shoulder waist]
          }]
      }
    }
  end

  def image_data
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAnElEQVR42u3RAQ0AAAgDIN8'\
  '/9K3hHFQg03Y4I0KEIEQIQoQgRAhChAgRghAhCBGCECEIEYIQhAhBiBCECEGIEIQgRAhChCBECEKEIAQhQhAiBCFCECIEIQgRghA'\
  'hCBGCECEIQYgQhAhBiBCECEEIQoQgRAhChCBECEIQIgQhQhAiBCFCEIIQIQgRghAhCBGCECFChCBECEKEIOS7BchtK0ieNE3rAAAAAElFTkSuQmCC'
  end
end
