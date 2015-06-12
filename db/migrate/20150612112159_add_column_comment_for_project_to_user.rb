class AddColumnCommentForProjectToUser < ActiveRecord::Migration
  def change
    add_column :users, :comment_for_project, :string, default: ""
  end
end
