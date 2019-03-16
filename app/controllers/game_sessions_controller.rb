# frozen_string_literal: true

class GameSessionsController < ApplicationController
  before_action :require_user!
  before_action :require_access!, except: [:create]

  def create
    redirect_to GameSession.create!(users: [current_user])
  end

  def show
    @game_session = GameSession.find(params[:id])
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
    params.require(:game_session).permit(:game_id)
  end
end
