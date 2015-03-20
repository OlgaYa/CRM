class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :meeting_id 
      t.string :title
      t.string :description
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
    end
  end
end
