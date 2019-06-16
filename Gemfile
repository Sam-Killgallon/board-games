# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.5.0'

gem 'devise', '~> 4.6'
gem 'google-cloud-storage', '~> 1.18', require: false
gem 'mini_magick', '~> 4.9.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0.0.beta2'
gem 'sendgrid-ruby', '~> 6.0.0'
gem 'turbolinks', '~> 5'
gem 'webpacker', '>= 4.0.0'

group :production do
  gem 'stackdriver', '~> 0.15.3'
end

group :development, :test do
  # Reduces boot times through caching; required in config/boot.rb
  gem 'bootsnap', '>= 1.1.0', require: false
  gem 'bullet', '~> 6.0.0'
  gem 'byebug', '~> 11.0', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 5.0'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 3.8'
end

group :development do
  gem 'annotate', '~> 2.7'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '~> 0.64'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'webdrivers', '~> 4.0'
end
