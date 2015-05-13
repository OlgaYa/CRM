class AddColumIdToMeeting < ActiveRecord::Migration
  def change
  	add_column :meetings, :event_id, :string
  	remove_column :meetings, :meeting_id
  end
end
