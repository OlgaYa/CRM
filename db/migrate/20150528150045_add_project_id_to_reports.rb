class AddProjectIdToReports < ActiveRecord::Migration
  def change
    remove_column :reports, :project

    add_column    :reports, :project_id, :integer
  end
end
