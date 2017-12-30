# frozen_string_literal: true

class OrderOption < ApplicationRecord
  belongs_to :order
  belongs_to :offer_quotation_gallery
  belongs_to :image, optional: true

  validate :not_more_than_one_option

  after_create :more_options_show

  def not_more_than_one_option
    errors.add(:order_id, "Can't select more than one option") if (image_id.present? && more_options.present?) ||
                                                       (image_id.present? && designer_pick.present?) ||
                                                       (more_options.present? && designer_pick.present?)
  end

  def more_options_show
  	if self.more_options
  		NotificationsMailer.new_option(self.order).deliver
  	end
  end
end
