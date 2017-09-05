# frozen_string_literal: true

describe V1::Users::HomeController, type: :controller do
  describe 'GET #mobile' do
    let(:user) { create :user }

    it 'returns 200 with a valid user logged in' do
      request.headers.merge! headers(user)
      get :mobile
      expect(response).to have_http_status 200
    end
  end

  private

  def headers(user)
    jwt = Auth.issue(resource: user.id)
    { Authorization: "Bearer #{jwt}" }
  end
end
