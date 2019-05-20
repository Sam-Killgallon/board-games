# frozen_string_literal: true

class Admin::GamesController < Admin::ApplicationController
  def index
    @games = Game.by_title
  end

  def show
    @game = Game.find(params[:id])
  end

  def new
    @game = Game.new
  end

  def edit
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      GenerateTextBoxImagePreview.call(@game)
      redirect_to [:admin, @game], notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  def update
    @game = Game.find(params[:id])

    if @game.update(game_params)
      redirect_to [:admin, @game], notice: 'Game was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.destroy
    redirect_to admin_games_path, notice: 'Game was successfully destroyed.'
  end

  private

  def game_params
    params.require(:game).permit(:title, :min_players, :max_players, :box_image)
  end
end
