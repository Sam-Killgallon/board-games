# frozen_string_literal: true

class GameSessions::UsersController < ApplicationController
  before_action :require_user!
  before_action :require_access!

  def update
    users = User.where(email: params[:emails])
    game_session.users = users

    redirect_to game_session
  end

  private

  def game_session
    return @game_session if defined?(@game_session)

    @game_session = GameSession.find(params[:game_session_id])
  end

  def require_access!
    current_user.game_sessions.exists?(params[:game_session_id]) || not_found
  end
end
