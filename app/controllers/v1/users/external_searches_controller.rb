# frozen_string_literal: true

class V1::Users::ExternalSearchesController < V1::Users::BaseController
  skip_before_action :authenticate
  def create
    es = ExternalSearch.find_or_initialize_by(query: params[:query])
    if es.persisted?
      es.count += 1
    else
      es.count = 1
    end
    if es.save
      render json: { message: 'Query saved' }, status: 200
    else
      render json: { errors: es.errors }, status: 400
    end
  end

  def search_suggestions
    suggestions = SearchSuggestion.order(serial_no: :asc).pluck(:name)
    render json: { data: suggestions }
  end

  def top_query_suggestions
    suggestions = TopQuerySuggestion.order(serial_no: :asc).pluck(:name)
    render json: { data: suggestions }
  end
end
