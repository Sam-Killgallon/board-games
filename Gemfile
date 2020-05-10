# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise', '~> 4.7'
gem 'google-cloud-storage', '~> 1.18', require: false
gem 'image_processing', '~> 1.9'
gem 'mini_magick', '~> 4.10.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '= 6.0.0'
gem 'sendgrid-ruby', '~> 6.0.0'
gem 'turbolinks', '~> 5'
gem 'webpacker', '>= 4.0.0'

group :production do
  gem 'stackdriver', '~> 0.16'
end

group :development, :test do
  gem 'bullet', '~> 6.1.0'
  gem 'byebug', '~> 11.0', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 5.0'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 4.0'
end

group :development do
  gem 'annotate', '~> 3.0'
  gem 'listen', '~> 3.2.1'
  gem 'rubocop', '~> 0.82', require: false
  gem 'rubocop-rails', '~> 2.5.2', require: false
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'shoulda-matchers', '~> 4.0'
end
