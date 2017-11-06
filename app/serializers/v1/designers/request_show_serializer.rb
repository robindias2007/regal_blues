
# frozen_string_literal: true

class V1::Designers::RequestShowSerializer < ActiveModel::Serializer
  attributes :username, :location, :sent_on, :item_type, :project, :size, :budget, :timeline, :images,
    :additional_description, :interested, :involved, :involved_time

  def username
    object.user.username.capitalize
  end

  def location
    object.address.country
  end

  def sent_on
    object.created_at.strftime('%d %b %Y')
  end

  def item_type
    object.sub_category.name
  end

  def project
    object.name
  end

  def size
    object.size.upcase
  end

  def budget
    object.max_budget&.round
  end

  def timeline
    "#{object.timeline - 2} weeks"
  end

  def images
    object.request_images.order(serial_number: :asc).map do |image|
      V1::Designers::RequestImageSerializer.new(image)
    end
  end

  def additional_description
    object.description
  end

  def interested
    !@rd&.not_interested?
  end

  def involved
    request_designer&.involved?
  end

  def involved_time
    request_designer&.updated_at
  end

  def request_designer
    @rd ||= RequestDesigner.find_by(designer_id: @instance_options[:designer_id], request: object)
  end
end
