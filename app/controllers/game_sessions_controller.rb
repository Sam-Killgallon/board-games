# frozen_string_literal: true

class GameSessionsController < ApplicationController
  before_action :require_user!
  before_action :require_access!, except: %i[create index]

  def index
    @game_sessions = case params[:filter]
                     when 'past'     then current_user.past_game_sessions
                     when 'upcoming' then current_user.upcoming_game_sessions
                     when 'created'  then current_user.created_game_sessions
                     else current_user.game_sessions
                     end
  end

  def create
    game_session = CreateGameSession.call(creator: current_user)
    redirect_to game_session
  end

  def show
    @game_session = GameSession.find(params[:id])
    @current_user_invitation = @game_session.invitations.find_by(user: current_user)
  end

  def update
    game_session = GameSession.find(params[:id])
    game_session.update(game_session_params)
    redirect_to game_session
  end

  private

  def require_access!
    current_user.game_sessions.exists?(params[:id]) || not_found
  end

  def game_session_params
    params.require(:game_session).permit(:game_id, :scheduled_at)
  end
end
