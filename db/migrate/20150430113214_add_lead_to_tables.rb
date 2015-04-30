class AddLeadToTables < ActiveRecord::Migration
  def up
    add_column :tables, :lead, :integer
  end

  def down
    remove_column :tables, :lead
  end

end
