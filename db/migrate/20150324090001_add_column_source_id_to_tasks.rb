class AddColumnSourceIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :source_id, :integer
  end
end
