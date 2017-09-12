# frozen_string_literal: true

describe V1::Users::HomeController, '#mobile' do
  describe 'with current_user' do
    describe 'and with requests' do
      before do
        user = create :user
        create_list(:request, 2, user: user)
        get home_mobile_path, params: {}, headers: { 'Authorization' => auth(user) }
      end

      it 'can respond with a list of requests' do
        expect(response.response_code).to eq 200
      end
    end

    describe 'but without any requests or orders' do
      before do
        user = create :user
        create_list(:product, 3)
        get home_mobile_path, params: {}, headers: { 'Authorization' => auth(user) }
      end

      it 'can respond with a list of recommended products' do
        expect(response.response_code).to eq 200
      end
    end

    describe 'without current_user' do
      before do
        create_list(:designer, 6)
        get home_mobile_path
      end

      it 'responds with a list of top designers' do
        expect(response.response_code).to eq 200
      end
    end
  end

  private

  def auth(user)
    jwt = Auth.issue(resource: user.id)
    "Bearer #{jwt}"
  end
end
