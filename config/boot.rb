# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
# Speed up boot time by caching expensive operations.
# Disabled on google app engine where the filesystem is in memory, and does not persist between
# restarts
require 'bootsnap/setup' if ENV['GAE_APPLICATION'].blank?
