class CreateTaskComments < ActiveRecord::Migration
  def change
    create_table :task_comments do |t|
      t.integer :task_id
      t.integer :comment_id

      t.timestamps null: false
    end
  end
end
