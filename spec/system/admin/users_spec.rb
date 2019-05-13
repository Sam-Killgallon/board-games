# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users' do
  let!(:users) { create_list(:user, 7) }
  before { login_as create(:user, :admin) }

  it 'lets an admin view users' do
    visit root_url
    click_on 'Admin panel'
    click_on 'Manage users'

    users.each do |user|
      expect(page).to have_content(user.id)
    end

    target_user = users[3]
    user_games = create_list(:game, 3)
    unowned_games = create_list(:game, 5)
    target_user.games = user_games

    click_on target_user.email
    expect(page).to have_content("#{target_user.email} - #{target_user.id}")

    user_games.each do |game|
      expect(page).to have_content(game.title)
    end

    unowned_games.each do |game|
      expect(page).to have_no_content(game.title)
    end
  end
end
