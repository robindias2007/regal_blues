# frozen_string_literal: true

Faker::Config.locale = 'en-IND' if Rails.env.test? || Rails.env.development?
