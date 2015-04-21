class RemovePercentageAnCountFromTables < ActiveRecord::Migration
  def change
  	remove_column :tables, :count, :integer
  	remove_column :tables, :percentage, :integer
  end
end
