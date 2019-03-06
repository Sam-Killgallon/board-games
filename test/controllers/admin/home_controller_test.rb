# frozen_string_literal: true

require 'test_helper'

class Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  extend AuthenticationHelpers

  not_found_for_normal_users('get admin root') { get '/admin' }

  test 'GET /admin returns success for admin users' do
    sign_in(create(:user, :admin))
    get '/admin'
    assert_response :success
  end
end
