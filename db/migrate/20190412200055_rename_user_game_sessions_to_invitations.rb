class RenameUserGameSessionsToInvitations < ActiveRecord::Migration[6.0]
  def change
    rename_table :user_game_sessions, :invitations
  end
end
