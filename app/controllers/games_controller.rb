# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :require_user!

  def index
    @games = current_user.games.by_title
  end

  def new
    @q = params[:q]

    partial_query = Game.all
    partial_query = partial_query.where(Game.arel_table[:title].matches("%#{@q}%")) if @q

    # Only return list games that the user doesn't already have
    @games = partial_query.where.not(id: current_user.game_ids).by_title
  end

  def update
    game = Game.find(params[:id])
    current_user.games << game
    redirect_to new_game_path, notice: "Added #{game.title} to your games"
  end

  def destroy
    current_user.games.destroy(params[:id])
    respond_to do |format|
      format.js   { @id = params[:id] }
      format.html { redirect_to games_path, notice: 'Game was successfully destroyed.' }
    end
  end
end
