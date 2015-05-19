class AddDateToTable < ActiveRecord::Migration

  def up
    add_column :tables, :date_status_1, :date
  end

  def down
    remove_column :tables, :date_status_1
  end
end
