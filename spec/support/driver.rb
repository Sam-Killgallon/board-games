# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end

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
