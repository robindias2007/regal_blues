# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
Rails.application.eager_load!

ActionController::AbstractRequest.relative_url_root = "https://limitless-brook-27912.herokuapp.com"

