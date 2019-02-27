# frozen_string_literal: true

require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'GET /admin returns not found with no user' do
    sign_in(create(:user))
    assert_raises(ActionController::RoutingError) do
      get '/admin'
    end
  end

  test 'GET /admin returns not found for non admin users' do
    sign_in(create(:user))
    assert_raises(ActionController::RoutingError) do
      get '/admin'
    end
  end

  test 'GET /admin returns success for admin users' do
    sign_in(create(:user, :admin))
    get '/admin'
    assert_response :success
  end
end
