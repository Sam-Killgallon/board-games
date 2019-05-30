class AddCreatorToInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :invitations, :creator, :boolean, default: false, null: false
  end
end
