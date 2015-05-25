class CreateProjects < ActiveRecord::Migration

  def up
    create_table :projects do |t|
      t.string :name, null: false, unique: true
      t.timestamps null: false
    end
    create_table :projects_users, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
    end
  end

  def down
    drop_table :projects
    drop_table :projects_users
  end

end
