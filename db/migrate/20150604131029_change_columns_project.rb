class ChangeColumnsProject < ActiveRecord::Migration
  def up
  	remove_column :projects, :status
  	remove_column :projects, :kind
  	add_column :projects, :status, :integer, default: 0
  	add_column :projects, :kind, :integer, default: 0
  end

  def down
  	change_column :projects, :status, :string
  	change_column :projects, :kind, :string
  end

end
