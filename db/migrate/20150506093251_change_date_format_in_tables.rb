class ChangeDateFormatInTables < ActiveRecord::Migration
  def up
    change_column :tables, :date, :datetime
  end

  def down
    change_column :tables, :date, :date
  end
end
