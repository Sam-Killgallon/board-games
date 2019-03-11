class CreateUserGameSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_game_sessions do |t|
      t.references :user, foreign_key: true
      t.references :game_session, foreign_key: true

      t.timestamps
    end
  end
end
