# frozen_string_literal: true

# User can either select the options before paying or ask for more options after paying.
# If the options are preselcted, state will transition from new -> paid -> awaiting_confirmation
# If the user asks for more options, state will transition from new -> paid -> awaiting_options.
# Then, awaiting_confirmation will be given.

class Order < ApplicationRecord
  include AASM
  include PushNotification

  belongs_to :designer
  belongs_to :user
  belongs_to :offer_quotation

  has_many :order_options, dependent: :destroy
  has_one :order_measurement, dependent: :destroy
  has_one :order_status_log, dependent: :destroy
  has_one :order_payment, dependent: :destroy
  has_many :notifications, as: :notificationable

  before_save :generate_order_id
  after_create :send_notifications

  accepts_nested_attributes_for :order_options, allow_destroy: true

  ###############################################################################################################
  # ############################################## Happy Path ###################################################
  # Pay -> Designer Confirm -> Give Measurements -> Produce Cloth -> Ship to QC -> Deliver to QC ->
  # Control Quality -> Ship to User -> Deliver to User
  #
  # ############################################## User Paths ###################################################
  # --------------------------------------- More Options + User Agrees ------------------------------------------
  # Pay -> User asks for more options -> Designer gives more options (== Designer confirmed) -> User Selects Options ->
  # Give Measurements -> Produce Cloth -> Ship to QC -> Deliver to QC -> Control Quality -> Ship to User ->
  # Deliver to User
  #
  # -------------------------------------- More Options + User Cancels ------------------------------------------
  # Pay -> User asks for more options -> Designer gives more options (== Designer confirmed) -> User cancels
  #
  # ---------------------------------------------- Designer's Pick ----------------------------------------------
  # User forfiets the option to select later if he chooses this option
  # Pay -> User asks for designer's choice (== User confirmed) -> Designer confirms -> Give Measurements ->
  # Produce Cloth -> Ship to QC -> Deliver to QC -> Control Quality -> Ship to User -> Deliver to User
  #
  # ############################################## Designer Paths ###############################################
  #
  # --------------------------------------- Fabric Unavailable + User Agrees ------------------------------------
  # NOTE: Does not matter if the designer sends out new options or asks to select among existing options,
  # the path will be the same.
  # Pay -> Designer says Fabric Unavailable -> User Selects Options (== User confirmed + Designer confirmed) ->
  # Give Measurements -> Produce Cloth -> Ship to QC -> Deliver to QC -> Control Quality -> Ship to User ->
  # Deliver to User
  #
  # ------------------------------------- Fabric Unavailable + User Cancels -------------------------------------
  # Pay -> Designer says Fabric Unavailable -> User cancels
  ###############################################################################################################

  #########################
  # User Actions          #
  # 1. Pay                #
  # 2. Give Measurements  #
  # 3. More Options       #
  # 4. Select Options     #
  # 5. Cancel the order   #
  #########################
  # Designer Actions      #
  # 1. Confirm the order  #
  # 2. Start Production   #
  # 3. Ship to QC         #
  # 4. Give more options  #
  # 5. Fabric Unavailable #
  #########################
  # Support Actions       #
  # 1. Delivered to QC    #
  # 2. In QC              #
  # 3. Ship to User       #
  # 4. Delivered to User  #
  # 5. Reject the product #
  #########################


  aasm column: 'status' do
    # Happy Path
    state :started, initial: true, after_enter: :update_datetime
    state :paid, after_enter: :update_datetime
    state :designer_confirmed, after_enter: :update_datetime
    state :measurements_given, after_enter: :update_datetime
    state :in_production, after_enter: :update_datetime
    state :shipped_to_qc, after_enter: :update_datetime, after_commit: :send_mail
    state :delivered_to_qc, after_enter: :update_datetime
    state :in_qc, after_enter: :update_datetime
    state :shipped_to_user, after_enter: :update_datetime, after_commit: :send_shipped_mail
    state :delivered_to_user, after_enter: :update_datetime, after_commit: :send_deliverd_mail
    state :rejected_by_qc, after_enter: :update_datetime, after_commit: :qc_reject_mail
    # User Path: More Options + User Agrees
    state :user_awaiting_more_options, after_enter: :update_datetime
    state :designer_gave_more_options, after_enter: :update_datetime#, after_commit: :new_option
    state :user_selected_options, after_enter: :update_datetime
    # User Path: More Options + User Cancels / Fabric Unavailable + User Cancels
    state :user_cancelled, after_enter: :update_datetime
    # Designer Path: Fabric Unavailable + User Agrees
    state :designer_selected_fabric_unavailable, after_enter: :update_datetime

    #state :unpaid, after_enter: :update_datetime

    # Actor: User
    # Actions: Pay
    event :pay do
      transitions from: :started, to: :paid
    end

    # Actor: Designer
    # Action: Confirm
    event :designer_confirms do
      transitions from: :paid, to: :designer_confirmed, gaurd: :all_options_selected?
    end

    # Actor: User
    # Action: Give Measurements
    event :give_measurements do
      transitions from: :designer_confirmed, to: :measurements_given
      transitions from: :user_selected_options, to: :measurements_given
    end

    # Actor: Designer
    # Action: Start Production
    event :start_production do
      transitions from: :measurements_given, to: :in_production
    end

    # Actor: Designer
    # Action: Ship To QC (Future: Have the delivery partner pick up automatically)
    event :ship_to_qc do
      transitions from: :in_production, to: :shipped_to_qc
    end

    # Actor: Support / Delivery Partner
    # Action: Deliver to QC
    event :deliver_to_qc do
      transitions from: :shipped_to_qc, to: :delivered_to_qc
    end

    # Actor: Support
    # Action: Recieved from Delivery Partner
    event :control_quality do
      transitions from: :delivered_to_qc, to: :in_qc
    end

    # Actor: Support
    # Action: Ship to User (Future: Have the delivery partner pick up automatically)
    event :ship_to_user do
      transitions from: :in_qc, to: :shipped_to_user
    end

    # Actor: Support / Delivery Partner
    # Action: Deliver to User
    event :deliver_to_user do
      transitions from: :ship_to_user, to: :delivered_to_user
    end

    # Actor: Support
    # Action: Reject the product
    event :reject_by_qc do
      transitions from: :in_qc, to: :rejected_by_qc
    end

    # Actor: User
    # Action: More Options (Take this from Order Options rather than having an option)
    event :user_asks_more_options do
      transitions from: :paid, to: :user_awaiting_more_options
    end

    # Actor: Designer
    # Action: More Options
    event :designer_gives_more_options do
      transitions from: :user_awaiting_more_options, to: :designer_gave_more_options
    end

    # Actor: User
    # Action: Choose from existing options / Designer Pick (Make sure no more_options boolean is true in order options)
    event :user_selects_options do
      transitions from: :designer_gave_more_options, to: :user_selected_options
      transitions from: :designer_selected_fabric_unavailable, to: :user_selected_options
    end

    # Actor: User
    # Action: Cancel the order
    event :user_cancels_the_order do
      transitions from: :designer_gave_more_options, to: :user_cancelled
      transitions from: :designer_selected_fabric_unavailable, to: :user_cancelled
    end

    # Actor: Designer
    # Action: Fabric Unavailable
    event :fabric_unavailable do
      transitions from: :paid, to: :designer_selected_fabric_unavailable
    end
  end

  def update_datetime
    osl = OrderStatusLog.find_or_initialize_by(order: self)
    osl["#{aasm.current_state}_at"] = Time.current
    osl.save
  end

  def all_options_selected?
    order_options.size == offer_quotation.offer_quotation_galleries.size
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update!(:"#{attr}" => false) : update!(:"#{attr}" => true)
  end

  def more_options_for_user?
    order_options.pluck(:more_options).include?(true)
  end

  def send_mail
    NotificationsMailer.under_qc(self).deliver_later
    begin
      body = "Your Order #{ self.order_id } has been delivered by the #{ self.designer.full_name } and is under QC."
      self.designer.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
      Order.new.send_notification(self.designer.devise_token, body, " ", extra_data)
    rescue
    end
  end

  def send_shipped_mail
    begin
      body = "Your order has been shipped Your Order #{ self.order_id } has been approved after QC and shipped to #{ self.user.full_name }"
      message = "Product Shipped -  Your order id #{self.order_id} for user #{self.user.full_name} has passed QC."
      NotificationsMailer.shipped_to_user(self).deliver_later
      NotificationsMailer.designer_shipped(self).deliver_later
      SmsService.send_message_notification(self.user.mobile_number, message)

      self.user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
      Order.new.send_notification(self.user.devise_token, body, "", extra_data)

      self.designer.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
      Order.new.send_notification(self.designer.devise_token, body, "", extra_data)
    rescue
    end
  end

  def qc_reject_mail
    begin
      body = "Your Order #{ self.order_id } for #{ self.user.full_name } has been rejected after QC"
      message = "Rejected in QC - Your order id #{self.order_id} for request #{self.offer_quotation.offer.request.name} by user #{ self.user.full_name } has failed quality check."
      NotificationsMailer.rejected_in_qc(self).deliver_later
      SmsService.send_message_notification(self.designer.mobile_number, message)
      self.designer.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
      Order.new.send_notification(self.designer.devise_token, body, "", extra_data)
    rescue
    end
  end

  def send_deliverd_mail
    NotificationsMailer.product_deliverd(self).deliver_later
    begin
      alert = "Product Delivered"
      body = "Your Order #{ self.order_id } has been successfully delivered to #{ self.user.full_name }"
      self.user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
      self.designer.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
      Order.new.send_notification(self.designer.devise_token, alert, body, extra_data) 
      Order.new.send_notification(self.user.devise_token, alert, body, extra_data)
    rescue
    end
  end

  def send_notifications
    begin
      self.delay(run_at: 24.hours.from_now).measurement_pending_notifications
      NotificationsMailer.order_accept(self).deliver_later
      body_d = "Your offer for #{self.offer_quotation.offer.request.name} has been accepted by #{ self.user.full_name}. Please confirm the order."

      message = "Awaiting Confirmation -  Please confirm order id #{self.order_id} for request #{self.offer_quotation.offer.request.name} by user #{self.user.full_name} immediately."
      SmsService.send_message_notification(self.designer.mobile_number, message)
      self.designer.notifications.create(body: body_d, notificationable_type: "Order", notificationable_id: self.id)
      Order.new.send_notification(self.designer.devise_token, body_d, "", extra_data)
    rescue
    end
  end

  def user_asked_more_option
    unless self.designer_gave_more_options?
      self.delay(run_at: 24.hours.from_now).user_asked_more_option
      user_name = self.user.full_name
      request_name = self.offer_quotation.offer.request.name

      alert = "Awaiting more options on your offer"

      body = "Your offer for #{request_name} has been accepted by #{user_name}. #{user_name} has asked for more option. Send more options."

      message = "Awaiting Options - Please send options for order id #{self.order_id} for request #{request_name} by user #{user_name} immediately."

      NotificationsMailer.more_option(self).deliver
      SmsService.send_message_notification(self.designer.mobile_number, message)
      Order.new.send_notification(self.designer.devise_token, alert, body, extra_data)
      self.designer.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
    end
  end

  def measurement_pending_notifications
    unless self.measurements_given?
      self.delay(run_at: 24.hours.from_now).measurement_pending_notifications

      body = "Your measurements are pending for Order  #{self.order_id}. #{self.designer.full_name} cannot start production until you give measurements."

      NotificationsMailer.give_measurement(self).deliver
      Order.new.send_notification(self.user.devise_token, body, " ", extra_data)
      self.user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: self.id)
    end
  end  

  private

  def generate_order_id
    return if order_id.present?
    self.order_id = generate_order_id_token
  end

  def extra_data
    return {type: "Order", id: self.id} rescue " "
  end

  def generate_order_id_token
    loop do
      token = SecureRandom.base58(6).tr('liO0', 'sxyz').upcase
      break token unless Order.find_by(order_id: token)
    end
  end

  def user_name
    return self.user.full_name rescue " "
  end

  def request_name
    return self.offer_quotation.offer.request.name rescue " "
  end

end
