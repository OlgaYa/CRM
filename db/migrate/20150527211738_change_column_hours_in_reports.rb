class ChangeColumnHoursInReports < ActiveRecord::Migration
  def up
    change_column :reports, :hours, :real
  end

  def down
    change_column :reports, :hours, :integer
  end
end
