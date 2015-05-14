class AddTypeForMeeting < ActiveRecord::Migration
  def change
  	add_column :meetings, :for_type, :string
  end
end
