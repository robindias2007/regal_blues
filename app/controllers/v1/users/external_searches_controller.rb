# frozen_string_literal: true

class V1::Users::ExternalSearchesController < V1::Users::BaseController
  skip_before_action :authenticate
  def create
    es = ExternalSearch.find_or_initialize_by(query: params[:query])
    if es.save
      render json: { message: 'Query saved' }, status: 200
    else
      render json: { errors: es.errors }, status: 400
    end
  end

  def search_suggestions
    suggestions = %W[
      Wedding
      Fashion
      Bollywood
      Ethnic
      LFW
      Runway
      #{"Trending Lehengas"}
      Anarkali
      Indowestern
    ]
    render json: { data: suggestions }
  end

  def top_query_suggestions
    suggestions = %W[Wedding Simple Ideas Bridal Casual Indowestern Fashion Bollywood Latest indian 2017
                     #{"Manish Malhotra"} #{"Anita Dongre"} Designer Engagement LFW Floral Elegant Pattern Embroidered
                     Trendy Ethnic Modern Printed]
    render json: { data: suggestions }
  end
end
