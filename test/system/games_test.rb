# frozen_string_literal: true

require 'application_system_test_case'

class GamesTest < ApplicationSystemTestCase
  setup do
    [
      'Betrayal at house on the hill',
      'Game of Thrones',
      'Splendor',
      'Betrayal legacy',
      'Munchkin',
      'Ticket to ride'
    ].each { |title| create(:game, title: title) }

    login_as(create(:user))
  end

  test 'user adds owned games' do
    visit root_url
    click_on 'Games'
    # Message to prompt user to add games
    assert_text "You don't have any games! Add some using the button below"
    click_on 'Add game'

    check 'Game of Thrones'
    check 'Munchkin'
    check 'Ticket to ride'

    click_on 'Save'

    # There should not longer be a message prompting use to add games
    assert_no_text "You don't have any games! Add some using the button below"

    # The chosen games should be in the list
    assert_text 'Game of Thrones'
    assert_text 'Munchkin'
    assert_text 'Ticket to ride'
  end
end
