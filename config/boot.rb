# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
# Speed up boot time by caching expensive operations.
# Disabled in production as the app is hosted on google cloud where the filesystem is in memory,
# and does not persist between restarts
require 'bootsnap/setup' unless ENV['RAILS_ENV'].eql?('production')
