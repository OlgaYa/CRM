class AddColumnTopicToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :topic, :string
  end  
end
