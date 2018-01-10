# frozen_string_literal: true

ruby '2.3.4'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'

# Use Puma as the app server
gem 'puma', '~> 3.7'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

# Authentication
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'devise'
gem 'google-api-client'
gem 'jwt'
gem 'signet'

# REST Client
gem 'httparty'

# Messaging Service
gem 'twilio-ruby'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Enumerization
gem 'enumerize'

# Serializer
gem 'active_model_serializers', require: true

# Image Upload and Manipulation
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'carrierwave-base64'
gem 'mini_magick'
gem 'rmagick'

# Faker / Seed Helper
gem 'faker'

# State Machine
gem 'aasm'

# AWS
gem 'aws-sdk-sns'

# Form Builder
gem 'simple_form'

# CSS Framework
gem 'materialize-sass'

# Push Notification
gem 'houston', '~> 2.2', '>= 2.2.3'

# Pagination for APi's
gem 'kaminari'
# gem 'will_paginate'
gem 'pager_api' , :github => 'BrahimDahmani/pager-api', :branch => "bugfixes"

group :development, :test do
  gem 'bullet'
  gem 'bundler-audit'
  gem 'factory_girl_rails'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rspec-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'fakeredis', require: 'fakeredis/rspec'
  gem 'shoulda-callback-matchers'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
