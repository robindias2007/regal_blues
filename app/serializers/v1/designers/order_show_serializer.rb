# frozen_string_literal: true

class V1::Designers::OrderShowSerializer < ActiveModel::Serializer
  attributes :id, :request_images, :username, :status_and_date, :request_name, :category, :size, :timeline,
    :shipping_address, :budget, :user_note, :measurements, :designer_note, :order_options, :user_avatar, :order_id

  def request_images
    request.request_images.order(serial_number: :asc).map do |image|
      V1::Designers::RequestImageSerializer.new(image)
    end
  end

  def username
    object.user.username
  end

  def user_avatar
    object.user&.avatar
  end

  def status_and_date
    {
      status: object.status.to_s.humanize + ' at',
      data:   object.order_status_log&.send("#{object.status}_at")&.strftime('%d %b %Y')
    }
  end

  def request_name
    request&.name
  end

  def category
    request.sub_category.name
  end

  def size
    request&.size
  end

  def timeline
    "#{request&.timeline - 2} weeks"
  end

  def shipping_address
    request.address.country
  end

  def budget
    request&.max_budget
  end

  def user_note
    request.description
  end

  def measurements
    object.offer_quotation.offer_measurements.first.data
  end

  def designer_note
    object.offer_quotation.description
  end

  def order_options
    if object.order_options.present?
      object.order_options.map do |oo|
        ActiveModelSerializers::SerializableResource.new(oo,
          serializer: V1::Designers::OrderOptionsSerializer).as_json
      end
    end
  end

  private

  def request
    @request ||= object.offer_quotation.offer.request
  end
end
