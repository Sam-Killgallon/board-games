# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :require_user!

  def search
    searched = Game.arel_table[:title].matches("%#{params[:q]}%")
    @games = Game.where(searched).where.not(id: current_user.game_ids).by_title
  end

  def index
    @games = current_user.games.by_title
  end

  def new
    # Only return list games that the user doesn't already have
    @games = Game.where.not(id: current_user.game_ids).by_title
  end

  def update
    game = Game.find(params[:id])
    current_user.games << game
  end

  def destroy
    current_user.games.destroy(params[:id])
    redirect_to games_path, notice: 'Game was successfully destroyed.'
  end
end
