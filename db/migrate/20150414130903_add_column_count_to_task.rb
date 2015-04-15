class AddColumnCountToTask < ActiveRecord::Migration
  def change
  	add_column :tables, :count, :integer, default: 0
  	add_column :tables, :percentage, :integer, default: 0
  end
end
