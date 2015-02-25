class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :source
      t.string :skype
      t.string :email
      t.text :links
      t.date :date
      t.integer :user_id
      t.string :status

      t.timestamps null: false
    end
  end
end
