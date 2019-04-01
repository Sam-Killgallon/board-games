class AddIndexToUserGameSessions < ActiveRecord::Migration[6.0]
  def change
    add_index :user_game_sessions, [:user_id, :game_session_id], unique: true
  end
end
