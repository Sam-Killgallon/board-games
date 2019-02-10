# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
  end

  test 'should contain sign up link' do
    get root_url
    assert_match 'Sign up', @response.body
  end

  test 'should contain sign in link' do
    get root_url
    assert_match 'Sign in', @response.body
  end
end
