# frozen_string_literal: true

class GameSessions::UsersController < ApplicationController
  before_action :require_user!
  before_action :require_access!

  def create
    user = User.find_by!(email: user_params[:email])
    game_session.users << user

    redirect_to game_session
  end

  def update
    user = User.find(params[:id])
    invitation = Invitation.find_by!(user: user, game_session: game_session)
    invitation.update!(rsvp: user_params[:rsvp])
    redirect_to game_session
  end

  private

  def user_params
    params.require(:user).permit(:email, :rsvp)
  end

  def game_session
    return @game_session if defined?(@game_session)

    @game_session = GameSession.find(params[:game_session_id])
  end

  def require_access!
    game_session.users.exists?(current_user.id) || not_found
  end
end
