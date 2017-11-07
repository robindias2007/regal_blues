# frozen_string_literal: true

class V1::Designers::OrdersSerializer < ActiveModel::Serializer
  attributes :id, :status, :username, :category, :request_name, :timeline, :created_at, :budget, :image, :user_avatar,
    :order_id

  def username
    object.user.username
  end

  def user_avatar
    object.user&.avatar
  end

  def category
    request.sub_category.name
  end

  def request_name
    request&.name
  end

  def timeline
    request&.timeline
  end

  def created_at
    object.created_at.strftime('%d %b %Y')
  end

  def budget
    request&.max_budget
  end

  def image
    request.request_images.order(serial_number: :asc).first.image
  end

  def all_options_selected
    object.all_options_selected?
  end

  private

  def request
    @request ||= object.offer_quotation.offer.request
  end
end
