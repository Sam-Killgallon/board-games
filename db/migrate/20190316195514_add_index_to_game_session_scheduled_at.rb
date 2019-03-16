class AddIndexToGameSessionScheduledAt < ActiveRecord::Migration[6.0]
  def change
    add_index :game_sessions, :scheduled_at
  end
end
