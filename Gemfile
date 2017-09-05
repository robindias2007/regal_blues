# frozen_string_literal: true

ruby '2.4.1'
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

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

# Authentication
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
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
gem 'active_model_serializers'

group :development, :test do
  gem 'bullet'
  gem 'bundler-audit'
  gem 'factory_girl_rails'
  gem 'faker'
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
end

group :test do
  gem 'database_cleaner'
  gem 'fakeredis', require: 'fakeredis/rspec'
  gem 'shoulda-callback-matchers'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
