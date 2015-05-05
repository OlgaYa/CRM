class AddTableIdToMeeting < ActiveRecord::Migration
  def up
    add_reference :meetings, :table, index: true
    add_foreign_key :meetings, :tables
  end

  def down
    remove_foreign_key :meetings, :tables
    remove_reference :meetings, :table, index: true
  end

end
