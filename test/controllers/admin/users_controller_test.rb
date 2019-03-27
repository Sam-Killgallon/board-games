# frozen_string_literal: true

require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  extend AuthenticationHelpers

  setup do
    sign_in(create(:user, :admin))
    @user = create(:user)
  end

  not_found_for_normal_users('get admin users') { get '/admin/users' }
  not_found_for_normal_users('get admin show user') { get "/admin/users/#{@user.id}" }

  test 'GET /admin/users returns success for admin users' do
    get '/admin/users'
    assert_response :success
  end

  test 'GET /admin/users/:id returns success for admin users' do
    get "/admin/users/#{@user.id}"
    assert_response :success
  end
end
