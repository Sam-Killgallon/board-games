class AddRsvpToUserGameSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :user_game_sessions, :rsvp, :integer, default: 0, null: false
  end
end
