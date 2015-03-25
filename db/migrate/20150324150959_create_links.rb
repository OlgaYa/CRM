class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string  :alt
      t.string  :href
      t.integer :task_id 

      t.timestamps null: false
    end
  end
end
