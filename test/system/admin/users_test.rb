# frozen_string_literal: true

require 'application_system_test_case'

class Admin::UsersTest < ApplicationSystemTestCase
  setup do
    login_as(create(:user, :admin))
    @users = create_list(:user, 7)
  end

  test 'viewing users' do
    visit root_url
    click_on 'Admin panel'
    click_on 'Manage users'

    @users.each do |user|
      assert_text user.id
    end

    target_user = @users[3]
    user_games = create_list(:game, 3)
    unowned_games = create_list(:game, 5)
    target_user.games = user_games

    click_on target_user.email
    assert_text "#{target_user.email} - #{target_user.id}"

    user_games.each do |game|
      assert_text game.title
    end

    unowned_games.each do |game|
      assert_no_text game.title
    end
  end
end
