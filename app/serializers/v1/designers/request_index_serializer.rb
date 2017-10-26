# frozen_string_literal: true

class V1::Designers::RequestIndexSerializer < ActiveModel::Serializer
  # TODO: sent bids/awaiting bids, user avatar
  attributes :username, :sent_on, :item_type, :project, :budget, :timeline, :image, :offers, :interested

  def username
    object.user.username.capitalize
  end

  def user_avatar
    object.user.avatar.url
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

  def budget
    object.max_budget.round
  end

  def timeline
    "#{object.timeline - 2} weeks"
  end

  def image
    object.request_images.order(created_at: :asc).first&.image || 'Default Image URL'
  end

  def offers
    Offer.where(request: object, designer_id: @instance_options[:designer_id]).any?
  end

  def interested
    !RequestDesigner.find_by(designer_id: @instance_options[:designer_id], request: object)&.not_interested?
  end
end
