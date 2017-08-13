# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.facebook_key, Rails.application.secrets.facebook_secret,
    scope: 'public_profile,email', info_fields: 'email,first_name,last_name,cover'
end

OmniAuth.config.logger = Rails.logger
