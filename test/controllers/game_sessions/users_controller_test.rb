# frozen_string_literal: true

require 'test_helper'

class GameSessions::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  extend AuthenticationHelpers

  setup do
    @current_user = create(:user)
    @game_session = create(:game_session, users: [@current_user])
    sign_in(@current_user)
  end

  not_found_without_user('put /game_session/:id/users') { put "/game_sessions/#{@game_session.id}/users" }

  test 'only users that are part of the session can update it' do
    game_session = create(:game_session, users: [])
    assert_raises(ActionController::RoutingError) do
      put "/game_sessions/#{game_session.id}/users"
    end
  end

  test 'adds the supplied users to the game' do
    users = create_list(:user, 2) << @current_user
    user_emails = users.map(&:email)

    put "/game_sessions/#{@game_session.id}/users", params: {
      users: { emails: user_emails }
    }

    assert_redirected_to "/game_sessions/#{GameSession.last.id}"
    assert_equal users.map(&:id).sort, @game_session.reload.users.map(&:id).sort
  end
end
