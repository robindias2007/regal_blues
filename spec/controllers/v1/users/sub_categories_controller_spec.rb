# frozen_string_literal: true

describe V1::Users::SubCategoriesController, type: :controller do
  describe 'GET #index' do
    let(:user) { create :user }

    before do
      create_list :sub_category, 5
    end

    it 'returns a list of requests of a particular user' do
      request.headers.merge! headers(user)
      get :index
      expect(response).to have_http_status 200
    end

    it 'returns http unauthorized if valid jwt is not passed' do
      get :index
      expect(response).to have_http_status 401
    end
  end

  private

  def headers(user)
    jwt = Auth.issue(resource: user.id)
    { Authorization: "Bearer #{jwt}" }
  end
end
