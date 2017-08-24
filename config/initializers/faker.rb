# frozen_string_literal: true

unless Rails.env.production? || Rails.env.staging?
  Faker::Config.locale = 'en-IND'
end
