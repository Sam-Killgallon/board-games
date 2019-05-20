# frozen_string_literal: true

class CreateGameSession
  def self.call(creator:)
    new.call(creator: creator)
  end

  def call(creator:)
    game_session = GameSession.new
    Invitation.create!(game_session: game_session, user: creator, creator: true)
    game_session
  end
end
