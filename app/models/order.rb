# frozen_string_literal: true

# User can either select the options before paying or ask for more options after paying.
# If the options are preselcted, state will transition from new -> paid -> awaiting_confirmation
# If the user asks for more options, state will transition from new -> paid -> awaiting_options.
# Then, awaiting_confirmation will be given.

class Order < ApplicationRecord
  include AASM

  belongs_to :designer
  belongs_to :user
  belongs_to :offer_quotation

  has_many :order_options, dependent: :destroy

  aasm column: 'status' do
    state :started, initial: true
    state :paid
    state :awaiting_options
    state :awaiting_confirmation
    state :awaiting_measurements
    state :confirmed
    state :shipped_to_qc
    state :in_qc
    state :shipped_to_user
    state :delivered
    state :rejected

    # When the payment comes back successfull, this will be transitioned from started to paid.
    # If the payment fails, then it remains at started
    event :pay do
      transitions from: :started, to: :paid # , gaurd: :payment_successful?
    end

    event :select_options do
      transitions from: :paid, to: :awaiting_options
    end

    # When a user completes selecting the options
    event :await_confirmation do
      transitions from: :awaiting_options, to: :awaiting_confirmation # , gaurd: :all_options_selected?
    end

    event :give_measurements do
      transitions from: :awaiting_confirmation, to: :awaiting_measurements
    end

    # When a designer confirms the order.
    event :confirmation do
      transitions from: :awaiting_measurements, to: :confirmed
    end

    # When a designer clicks on the ship_to_qc button. If he/she forgets, support should be able to do it.
    event :ship_to_qc do
      transitions from: :confirmed, to: :shipped_to_qc
    end

    # Support clicks the recieved product button for this order
    event :quality_control do
      transitions from: :shipped_to_qc, to: :in_qc
    end

    # Support ships the product / Delivery guy picks up the order to be shipped
    event :ship do
      transitions from: :in_qc, to: :shipped_to_user
    end

    # When the delivery partner notifies us of a product being delivered
    event :deliver do
      transitions from: :shipped_to_user, to: :delivered
    end

    # When the support rejects the product due to low quality/other reasons
    event :reject do
      transitions from: :in_qc, to: :rejected
    end
  end
end
