class RenameUserGameToOwnership < ActiveRecord::Migration[6.0]
  def change
    rename_table :user_games, :ownerships
  end
end
