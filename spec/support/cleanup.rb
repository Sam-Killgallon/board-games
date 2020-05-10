# frozen_string_literal: true

RSpec.configure do |config|
  delete_uploaded_files = -> { FileUtils.rm_rf(Rails.root.join('tmp/storage')) }

  config.before(:suite) do
    delete_uploaded_files.call
  end

  config.after(:each) do
    delete_uploaded_files.call
  end
end
