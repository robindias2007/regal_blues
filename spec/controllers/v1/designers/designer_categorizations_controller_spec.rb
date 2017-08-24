# frozen_string_literal: true

describe V1::Designers::DesignerCategorizationsController, type: :controller do
  describe 'GET #index' do
    let(:designer) { create :designer }

    before do
      sub_category = create :sub_category
      create :designer_categorization, designer: designer, sub_category: sub_category
    end

    it 'returns a list of requests of a particular designer' do
      request.headers.merge! headers(designer)
      get :index
      expect(response).to have_http_status 200
    end

    it 'returns http unauthorized if valid jwt is not passed' do
      get :index
      expect(response).to have_http_status 401
    end
  end

  private

  def headers(designer)
    jwt = Auth.issue(resource: designer.id)
    { Authorization: "Bearer #{jwt}" }
  end
end
