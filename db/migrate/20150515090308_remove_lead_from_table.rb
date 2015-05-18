class RemoveLeadFromTable < ActiveRecord::Migration

  def up
  	remove_column :tables, :lead
  end

  def down
    add_column :tables, :lead, :integer
  end

end
