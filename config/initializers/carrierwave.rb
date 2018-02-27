# frozen_string_literal: true

require 'carrierwave/orm/activerecord'

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

    def validate_dimensions
      manipulate! do |img|
        raise CarrierWave::ProcessingError, 'dimensions exceed limits' if img.dimensions.any? { |i| i > 4000 }
        img
      end
    end
  end
end

CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV['S3_BUCKET']
  config.aws_acl    = 'public-read'

  # The maximum period for authenticated_urls is only 7 days.
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  # Set custom options such as cache control to leverage browser caching
  config.aws_attributes = {
    expires:       1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }

  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY'] ,
    secret_access_key: ENV['AWS_SECRET_KEY'],
    region:            ENV['AWS_REGION']
  }
end