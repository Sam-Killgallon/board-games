# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :require_user!

  def index
    @games = current_user.games
  end

  def new
    # Only return list games that the user doesn't already have
    @games = Game.where.not(id: current_user.game_ids)
  end

  def create
    games = Game.find(params[:games])
    current_user.games << games

    redirect_to games_path
  end

  def destroy
    current_user.games.destroy(params[:id])
    redirect_to games_path, notice: 'Game was successfully destroyed.'
  end
end
