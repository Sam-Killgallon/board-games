# frozen_string_literal: true

require 'application_system_test_case'

class UserAccountsTest < ApplicationSystemTestCase
  test 'signing up' do
    visit root_url
    click_on 'Sign up'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'
    assert_selector 'p', text: 'Welcome! You have signed up successfully'
  end

  test 'signing in and logging out' do
    user = create(:user)
    visit root_url
    click_on 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    assert_selector 'p', text: 'Signed in successfully'

    click_on 'Sign out'
    assert_selector 'p', text: 'Signed out successfully'
  end
end
