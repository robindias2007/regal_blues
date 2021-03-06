# frozen_string_literal: true

class V1::Users::ExploreController < V1::Users::BaseController
  skip_before_action :authenticate, only: %i[mobile mobile_v2]

  def mobile
    categories = SubCategory.order(serial_no: :asc)
    top_three = categories.sample(3)
    designers = Designer.where(gold:true).order(created_at: :asc).limit(6)

    render json: {
      categories: categories_serializer(categories),
      products:   products_serializer(top_three),
      designers:  designers_serializer(designers)
    }
  end

  def mobile_v2
    categories = SubCategory.order(serial_no: :asc)
    designers =  Designer.where(gold:true).order(created_at: :asc).limit(6)

    render json: {
      categories: categories_serializer(categories),
      designers:  designers_serializer(designers)
    }
  end

  private

  def serialization_for(list, serializer)
    ActiveModelSerializers::SerializableResource.new(list,
      each_serializer: serializer)
  end

  def categories_serializer(categories)
    serialization_for(categories, V1::Users::RequestSubCategorySerializer)
  end

  def designers_serializer(designers)
    serialization_for(designers, V1::Users::TopDesignersSerializer)
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
    first = top_three.first
    second = top_three.second
    third = top_three.last
    {
      1 => { category: first.name, id: first.id,  data: first_category_products(top_three) },
      2 => { category: second.name, id: second.id, data: second_category_products(top_three) },
      3 => { category: third.name, id: third.id,  data: last_category_products(top_three) }
    }
  end
end
