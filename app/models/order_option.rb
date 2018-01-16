# frozen_string_literal: true

class OrderOption < ApplicationRecord
  include PushNotification
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
  		NotificationsMailer.new_option(self.order).deliver_later
      begin
        body = "You have new options for Order <%= self.order.order_id %> by <%= self.order.user.full_name%>. Please select new options."
        self.order.user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.order.id)
        OrderOption.new.send_notification(self.order.user.devise_token, body, body)
      rescue
      end
  	end
  end
end
