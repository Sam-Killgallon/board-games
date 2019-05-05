# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserAccounts' do
  it 'allows signing up' do
    visit root_url
    click_on 'Sign up'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    within('#new_user') { click_on 'Sign up' }
    expect(page).to have_content('Welcome! You have signed up successfully')
  end

  it 'allow signing in and logging out' do
    user = create(:user)
    visit root_url
    click_on 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully')

    click_on 'Sign out'
    expect(page).to have_content('Signed out successfully')
  end

  it 'allows changing account info' do
    user = create(:user)
    new_email = 'my_new_email@example.com'
    login_as(user)

    # Edit account details
    visit root_url
    click_on user.email
    fill_in 'Email', with: new_email
    fill_in 'Current password', with: user.password
    click_on 'Update'
    expect(page).to have_content('Your account has been updated successfully')

    click_on 'Sign out'

    # Check that we can sign in using the new details
    visit new_user_session_url
    fill_in 'Email', with: new_email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully')
  end
end
