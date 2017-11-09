# frozen_string_literal: true

class V1::Designers::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :store_display_name, :email, :location, :min_order_price, :avatar, :mobile_number, :bio, :active,
    :store_info_id, :verified, :confirmed, :approved

  def store_display_name
    object.designer_store_info.display_name
  end

  def min_order_price
    object.designer_store_info.min_order_price
  end

  def store_info_id
    object.designer_store_info.id
  end

  def confirmed
    object.confirmed?
  end

  def approved
    object.approved?
  end
end
