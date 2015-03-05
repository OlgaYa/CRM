class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.datetime :datetime
      t.integer :user_id
      t.integer :task_id

      t.timestamps null: false
    end
  end
end
