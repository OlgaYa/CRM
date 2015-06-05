class AddColumnToUser < ActiveRecord::Migration

  def up
  	add_column :users, :group, :integer,  :null => true
  end

  def down
  	remove_column :users, :group
  end

end
