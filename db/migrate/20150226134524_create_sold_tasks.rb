class CreateSoldTasks < ActiveRecord::Migration
  def change
    create_table :sold_tasks do |t|
      t.integer :task_id
      t.integer :price
      t.date :date_start
      t.date :date_end
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
