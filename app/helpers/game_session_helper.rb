# frozen_string_literal: true

module GameSessionHelper
  def past_game_sessions_path
    game_sessions_path(filter: 'past')
  end

  def upcoming_game_sessions_path
    game_sessions_path(filter: 'upcoming')
  end
end
