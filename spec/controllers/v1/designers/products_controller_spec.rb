# frozen_string_literal: true

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
        selling_price:           Faker::Commerce.price,
        sub_category_id:         sc.id,
        product_info_attributes: [color: Faker::Color.color_name,
          fabric: 'lorem', care: 'lorem', notes: 'lorem', work: 'lorem'],
        images_attributes:       [image: 'asd', width: 10, height: 10]
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
end
