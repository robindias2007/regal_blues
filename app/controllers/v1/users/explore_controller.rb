# frozen_string_literal: true

class V1::Users::ExploreController < V1::Users::BaseController
  skip_before_action :authenticate, only: :mobile

  def mobile
    categories = SubCategory.order(name: :asc)
    top_three = categories.sample(3)
    designers = Designer.order('RANDOM()').limit(6)

    render json: {
      categories: categories_serializer(categories),
      products:   products_serializer(top_three),
      designers:  designers_serializer(designers)
    }
  end

  private

  def categories_serializer(categories)
    serialization_for(categories, V1::Users::RequestSubCategorySerializer)
  end

  def designers_serializer(designers)
    serialization_for(designers, V1::Users::TopDesignersSerializer)
  end

  def serialization_for(list, serializer)
    ActiveModelSerializers::SerializableResource.new(list,
      each_serializer: serializer)
  end

  def serialize_products(products)
    serialization_for(products, V1::Users::ProductsSerializer)
  end

  def first_category_products(top_three)
    serialize_products Product.where(sub_category: top_three.first).order('RANDOM()').limit(6)
  end

  def second_category_products(top_three)
    serialize_products Product.where(sub_category: top_three.second).order('RANDOM()').limit(6)
  end

  def last_category_products(top_three)
    serialize_products Product.where(sub_category: top_three.last).order('RANDOM()').limit(6)
  end

  def products_serializer(top_three)
    first_cat = top_three.first.name
    second_cat = top_three.second.name
    last_cat = top_three.last.name

    {
      first_cat  => first_category_products(top_three),
      second_cat => second_category_products(top_three),
      last_cat   => last_category_products(top_three)
    }
  end
end
