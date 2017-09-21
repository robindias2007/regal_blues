# frozen_string_literal: true

class V1::Designers::RequestIndexSerializer < ActiveModel::Serializer
  attributes :username, :sent_on, :item_type, :project, :budget, :timeline, :image

  def username
    object.user.username.capitalize
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
    "#{object.timeline} weeks"
  end

  def image
    object.images.first&.image || 'Default Image URL'
  end
end
