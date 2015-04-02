# Not typed table
class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :type
      t.string :name
      t.integer :level_id
      t.integer :specialization_id
      t.string :email
      t.integer :source_id
      t.date :date
      t.integer :status_id
      t.string :topic
      t.string :skype
      t.integer :user_id
      t.integer :price
      t.date :date_start
      t.date :date_end

      t.timestamps null: false
    end
  end
end
