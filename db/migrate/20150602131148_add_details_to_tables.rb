class AddDetailsToTables < ActiveRecord::Migration

  def up
    add_column :tables, :details, :text
  end

  def down
    remove_column :tables, :details
  end

end
