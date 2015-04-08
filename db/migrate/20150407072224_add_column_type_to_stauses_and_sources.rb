class AddColumnTypeToStausesAndSources < ActiveRecord::Migration
  def self.up
    add_column :statuses, :for_type, :string, default: 'sale'
    add_column :sources, :for_type, :string, default: 'sale'
  end

  def self.down
    remove_column :statuses, :for_type
    remove_column :sources, :for_type
  end
end
