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
          [name: Faker::Commerce.product_name, images_attributes: [image: 'asd']]],
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
end
