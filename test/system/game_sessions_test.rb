# frozen_string_literal: true

require 'application_system_test_case'

class GameSessionsTest < ApplicationSystemTestCase
  setup do
    @current_user = create(:user)
    login_as(@current_user)
  end

  test 'user browses game sessions' do
    past_game_sessions = create_list(:game_session, 13, :past, users: [@current_user])
    upcoming_game_sessions = create_list(:game_session, 7, :upcoming, users: [@current_user])
    unscheduled_game_sessions = create_list(:game_session, 6, :unscheduled, users: [@current_user])

    visit root_url
    within '#past-game-sessions' do
      # Show last 10 sessions
      past_game_sessions.last(10).each { |game_session| assert_text game_session.id }
      click_on 'View all past game sessions'
    end
    past_game_sessions.each { |game_session| assert_text game_session.id }

    visit root_url
    within '#upcoming-game-sessions' do
      # Prioritise showing upcoming sessions
      upcoming_game_sessions.each { |game_session| assert_text game_session.id }
      # Fill in remaining space with unscheduled (up to a total of 10)
      unscheduled_game_sessions.first(3).each { |game_session| assert_text game_session.id }
      click_on 'View all upcoming game sessions'
    end
    upcoming_game_sessions.each { |game_session| assert_text game_session.id }
    unscheduled_game_sessions.each { |game_session| assert_text game_session.id }

    click_on 'All'

    (past_game_sessions + upcoming_game_sessions + unscheduled_game_sessions).each do |game_session|
      assert_text game_session.id
    end
  end

  test 'user creates game session with friends' do
    current_user_games = create_list(:game, 3)
    @current_user.games = current_user_games
    friend1_games = create_list(:game, 2)
    friend1 = create(:user, games: friend1_games)
    friend2_games = create_list(:game, 5)
    friend2 = create(:user, games: friend2_games)
    # To check that only distinct games are shown in the UI
    friend3_games = friend2_games + create_list(:game, 2)
    friend3 = create(:user, games: friend3_games)
    unowned_games = create_list(:game, 10)

    visit root_url
    click_on 'Create session'

    fill_in 'Player email', with: friend1.email
    click_on 'Add player'

    fill_in 'Player email', with: friend2.email
    click_on 'Add player'

    fill_in 'Player email', with: friend3.email
    click_on 'Add player'

    # Should list the current user with the players + in the navbar
    assert_text @current_user.email, minimum: 2
    # Should list all the players
    [friend1, friend2, friend3].each do |user|
      assert_text user.email
    end

    # Should have a list of all the available games
    (current_user_games + friend1_games + friend2_games + friend3_games).each do |game|
      # Avoid partial matching; ie game_title_1 will match game_title_10
      assert_text(/#{game.title}\b/, count: 1)
    end

    # Should not show games that none of the players have
    unowned_games.each do |game|
      assert_no_text game.title
    end

    assert_no_text 'Chosen game'
    chosen_game = friend2_games.first
    find('li', text: chosen_game.title).click_on 'Choose game'
    assert_text "Chosen game: #{chosen_game.title}"

    target_date = 1.week.from_now
    find('input#game_session_scheduled_at').click
    find("[aria-label=\"#{target_date.strftime('%B %e, %Y').squish}\"]", visible: false).click
    click_on 'Schedule'
    assert_text 'Scheduled at: In 7 days'
  end

  test 'user responds to game invitation' do
    session_creator = create(:user)
    session = create(:game_session, users: [session_creator, @current_user])

    visit root_url
    click_on session.id.to_s

    within '#invited' do
      assert_text @current_user.email
      assert_text session_creator.email
    end
    within '#attending' do
      assert_no_text @current_user.email
      assert_no_text session_creator.email
    end

    click_on 'Attend'

    within '#invited' do
      assert_no_text @current_user.email
      assert_text session_creator.email
    end
    within '#attending' do
      assert_text @current_user.email
      assert_no_text session_creator.email
    end
  end
end
