# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Games' do
  before do
    create(:game)
    login_as create(:user, :admin)
  end

  it 'creates a Game' do
    visit root_url
    click_on 'Admin panel'
    click_on 'Manage games'
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

    expect(page).to have_content('Game was successfully created')
    expect(page).to have_content(new_game_details[:title])
  end

  it 'updates a Game' do
    new_title = 'FooBar Game'

    visit root_url
    click_on 'Admin panel'
    click_on 'Manage games'
    click_on 'Edit', match: :first

    fill_in 'Title', with: new_title
    click_on 'Update Game'

    expect(page).to have_content('Game was successfully updated')
    expect(page).to have_content(new_title)
    click_on 'Back'
  end

  it 'destroys a Game', js: true do
    visit root_url
    click_on 'Admin panel'
    click_on 'Manage games'
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    expect(page).to have_content('Game was successfully destroyed')
  end
end
