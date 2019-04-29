# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @past_game_sessions     = past_game_sessions
    @upcoming_game_sessions = upcoming_game_sessions
  end

  private

  def past_game_sessions
    return [] unless user_signed_in?
    current_user.past_game_sessions.limit(10).order(scheduled_at: :desc)
  end

  def upcoming_game_sessions
    return [] unless user_signed_in?
    current_user.upcoming_game_sessions.limit(10).order(scheduled_at: :asc)
  end
end
