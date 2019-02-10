class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    # 0 is expected to map to the normal :user role
    add_column :users, :role, :integer, default: 0, null: false
  end
end
