class CreateUserPermissions < ActiveRecord::Migration
  def up
    create_table :user_permissions, id: false do |t|
      t.integer :user_id
      t.integer :permission_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :user_permissions
  end
end
