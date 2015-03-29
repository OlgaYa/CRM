class RemoveColumnStatusFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :status
  end
end
