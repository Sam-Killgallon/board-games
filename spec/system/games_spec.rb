# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games' do
  before do
    [
      'Betrayal at house on the hill',
      'Game of Thrones',
      'Splendor',
      'Betrayal legacy',
      'Munchkin',
      'Ticket to ride'
    ].each { |title| create(:game, title: title) }

    login_as create(:user)
  end

  it 'allows users to search for owned game', js: true do
    visit root_url
    click_on 'Games'
    # Message to prompt user to add games
    expect(page).to have_content("You don't have any games! Why not add one?")
    click_on 'Add New Game'

    find('input[type="search"]').set("game o\n")
    find('tr', text: 'Game of Thrones').click_on 'Add game'

    find('input[type="search"]').set("chki\n")
    find('tr', text: 'Munchkin').click_on 'Add game'

    find('input[type="search"]').set("ride\n")
    find('tr', text: 'Ticket to ride').click_on 'Add game'

    click_on 'Back'

    # There should not longer be a message prompting use to add games
    expect(page).to have_no_content("You don't have any games! Add some using the button below")

    # The chosen games should be in the list
    expect(page).to have_content('Game of Thrones')
    expect(page).to have_content('Munchkin')
    expect(page).to have_content('Ticket to ride')
  end
end
