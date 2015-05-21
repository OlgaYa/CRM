class CreateReport < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string   :project
      t.string   :task
      t.integer  :user_id
      t.integer  :hours
      t.date     :date

      t.timestamps null: false
    end
  end
end
