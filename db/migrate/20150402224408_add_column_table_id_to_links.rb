class AddColumnTableIdToLinks < ActiveRecord::Migration
  def change
    add_column :links, :table_id, :integer
  end
end
