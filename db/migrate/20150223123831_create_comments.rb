class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.datetime :datetime

      t.timestamps null: false
    end
  end
end
