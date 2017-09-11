# frozen_string_literal: true
#
# require 'google/apis/plus_v1'
# require 'signet/oauth_2/client'
#
# module Omniauth
#   class GoogleAuth
#     include Google
#     include Signet
#
#     def self.authenticate(code)
#       Google::Apis::PlusV1::PlusService.new.tap do |user_info|
#         user_info.key = Rails.application.secrets.goole_api_key
#         user_info.authorization = auth_client(code)
#       end
#     end
#
#     def self.auth_client(code)
#       Signet::OAuth2::Client.new(
#         authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
#         token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token',
#         client_id: Rails.application.secrets.google_client_id,
#         client_secret: Rails.application.secrets.google_client_secret,
#         scope: 'email profile', redirect_uri: 'http://localhost:4200/oauth2callback',
#         access_type: 'offline'
#       ).tap do |client|
#         client.code = code
#         client.fetch_access_token!
#       end
#     end
#   end
# end
