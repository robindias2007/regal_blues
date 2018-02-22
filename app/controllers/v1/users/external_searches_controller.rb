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
    suggestions = %W[
      #{"Indianwear 2017"}
      #{"Indian Wedding Outfit"}
      #{"Indian Cocktail Gown"}
      #{"Sangeet Outfit"}
      #{"India Fashion Week"}
      #{"Deepika Indian Outfits"}
      #{"Sonam Indian Outfits"}
      #{"Bollywood Indian Fashion"}
      #{"Bridesmaid Indian Outfits"}
    ]
    render json: { data: suggestions }
  end

  def top_query_suggestions
    suggestions = %W[Bridal #{"Fashion week"} #{"Couture Week"} Pakistani #{"For Kids"} 2017 Wedding Designer Simple Plain ]
    render json: { data: suggestions }
  end
end
