# frozen_string_literal: true

require 'application_system_test_case'

class Admin::GamesTest < ApplicationSystemTestCase
  setup do
    login_as(create(:user, :admin))
    @game = create(:game)
  end

  test 'creating a Game' do
    visit root_url
    click_on 'Admin panel'
    click_on 'Games'
    click_on 'Add new game'

    new_game_details = {
      title: 'Betrayal at house on the hill',
      min_players: '3',
      max_players: '6'
    }

    fill_in 'Title', with: new_game_details[:title]
    fill_in 'Min players', with: new_game_details[:min_players]
    fill_in 'Max players', with: new_game_details[:max_players]
    click_on 'Create Game'

    assert_text 'Game was successfully created'
    assert_text new_game_details[:title]
  end

  test 'updating a Game' do
    new_title = 'FooBar Game'
    assert_not_equal new_title, @game.title

    visit admin_games_url
    click_on 'Edit', match: :first

    fill_in 'Title', with: new_title
    click_on 'Update Game'

    assert_text 'Game was successfully updated'
    assert_text new_title
    click_on 'Back'
  end

  test 'destroying a Game' do
    visit admin_games_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Game was successfully destroyed'
  end
end
