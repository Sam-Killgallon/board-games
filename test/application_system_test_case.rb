# frozen_string_literal: true

require 'test_helper'

# HACK: Add arguments required to run chrome tests in docker
module ChromeOptionsExt
  def headless_chrome_browser_options
    super.tap do |opts|
      opts.add_argument('no-sandbox')
      opts.add_argument('disable-dev-shm-usage')
    end
  end
end

module ActionDispatch
  module SystemTesting
    class Browser
      prepend ChromeOptionsExt
    end
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  include Warden::Test::Helpers
end
