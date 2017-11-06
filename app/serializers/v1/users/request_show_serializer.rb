# frozen_string_literal: true

class V1::Users::RequestShowSerializer < ActiveModel::Serializer
  attributes :id, :sent_on, :status, :name, :item_type, :size, :timeline, :designers, :shipping_address,
    :budget, :description, :images, :offers_count

  def sent_on
    object.created_at.strftime('%d %b %Y')
  end

  def size
    object.size.upcase
  end

  def timeline
    "#{object.timeline} weeks"
  end

  def budget
    object.max_budget&.round
  end

  def item_type
    SubCategory.find(object.sub_category_id).name
  end

  def offers_count
    object.offers.count
  end

  def designers
    requests = RequestDesigner.where(request: object).order('RANDOM()')
    if requests.size == 1
      requests.first.designer.designer_store_info&.display_name
    elsif requests.size > 1
      "#{requests.first.designer.designer_store_info&.display_name} + #{requests.count - 1} other designers"
    else
      'No designers'
    end
  end

  def shipping_address
    ActiveModelSerializers::SerializableResource.new(object.address,
      serializer: V1::Users::AddressSerializer).as_json
  end

  def images
    object.request_images.order(serial_number: :asc).map do |image|
      ActiveModelSerializers::SerializableResource.new(image,
        serializer: V1::Designers::RequestImageSerializer).as_json
    end
  end
end
