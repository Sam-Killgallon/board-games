# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :system
end
