# frozen_string_literal: true

require 'test_helper'

class GameSessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  extend AuthenticationHelpers

  setup do
    @current_user = create(:user)
    @game_session = create(:game_session, users: [@current_user])
    sign_in(@current_user)
  end

  not_found_without_user('get /game_session/:id') { get "/game_sessions/#{@game_session.id}" }
  not_found_without_user('post /game_sessions') { post '/game_sessions' }
  not_found_without_user('put /game_sessions') { put '/game_sessions' }

  test 'creates a new session' do
    post '/game_sessions'
    assert_redirected_to "/game_sessions/#{GameSession.last.id}"
  end

  test 'add current_user to the created session' do
    post '/game_sessions'
    assert_includes GameSession.last.users, @current_user
  end

  test 'only users that are invited to the session can view it' do
    game_session = create(:game_session, users: [])
    assert_raises(ActionController::RoutingError) do
      get "/game_sessions/#{game_session.id}"
    end
  end

  test 'shows the session' do
    get "/game_sessions/#{@game_session.id}"
    assert_response :success
  end

  test 'updates the session' do
    game = create(:game)
    put "/game_sessions/#{@game_session.id}", params: {
      game_session: { game_id: game.id }
    }

    assert_redirected_to @game_session
    assert_equal game, @game_session.reload.game
  end
end
