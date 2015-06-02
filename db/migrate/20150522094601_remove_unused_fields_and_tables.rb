class RemoveUnusedFieldsAndTables < ActiveRecord::Migration
  def up
    remove_column :links, :task_id
    remove_column :messages, :task_id
    remove_column :users, :role
    drop_table :task_comments
    drop_table :sold_tasks
    drop_table :tasks
  end

  def down
  end
end
