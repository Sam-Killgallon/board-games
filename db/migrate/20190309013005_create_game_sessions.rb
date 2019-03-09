class CreateGameSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :game_sessions do |t|
      t.datetime :scheduled_at
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
