class AddColumnReminderDateForTables < ActiveRecord::Migration
  def self.up
    add_column :tables, :reminder_date, :datetime
  end

  def self.down
    remove_column :tables, :reminder_date
  end
end
