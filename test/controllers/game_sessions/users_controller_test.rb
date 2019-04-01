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

  not_found_without_user('put /game_session/:id/users') { post "/game_sessions/#{@game_session.id}/users" }

  test 'can only add users to a session the current user is part of' do
    new_game_session = create(:game_session, users: [])
    new_user = create(:user)
    assert_raises(ActionController::RoutingError) do
      post "/game_sessions/#{new_game_session.id}/users", params: {
        user: { email: new_user.email }
      }
    end
  end

  test 'adds user to session' do
    new_user = create(:user)
    post "/game_sessions/#{@game_session.id}/users", params: {
      user: { email: new_user.email }
    }

    assert_includes @game_session.reload.users, new_user
  end
end
