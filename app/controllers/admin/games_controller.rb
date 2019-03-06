# frozen_string_literal: true

class Admin::GamesController < Admin::ApplicationController
  before_action :set_game, only: %i[show edit update destroy]

  # GET /admin/games
  def index
    @games = Game.all
  end

  # GET /admin/games/1
  def show; end

  # GET /admin/games/new
  def new
    @game = Game.new
  end

  # GET /admin/games/1/edit
  def edit; end

  # POST /admin/games
  def create
    @game = Game.new(game_params)

    if @game.save
      redirect_to [:admin, @game], notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/games/1
  def update
    if @game.update(game_params)
      redirect_to [:admin, @game], notice: 'Game was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/games/1
  def destroy
    @game.destroy
    redirect_to admin_games_path, notice: 'Game was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def game_params
    params.require(:game).permit(:title, :min_players, :max_players)
  end
end
