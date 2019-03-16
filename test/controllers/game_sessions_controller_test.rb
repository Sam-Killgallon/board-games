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
  not_found_without_user('put /game_sessions/:id') { put "/game_sessions/#{@game_session.id}" }

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

  test 'only users that are part of the session can update it' do
    game_session = create(:game_session, users: [])
    assert_raises(ActionController::RoutingError) do
      put "/game_sessions/#{game_session.id}"
    end
  end

  test 'updates the game_session' do
    user_emails = create_list(:user, 2).map(&:email) << @current_user.email

    put "/game_sessions/#{@game_session.id}", params: {
      game_session: { user_emails: user_emails }
    }

    assert_redirected_to "/game_sessions/#{GameSession.last.id}"
    follow_redirect!
    user_emails.each do |email|
      assert_match email, @response.body
    end
  end
end
