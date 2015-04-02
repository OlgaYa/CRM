class CreateTableComments < ActiveRecord::Migration
  def change
    create_table :table_comments do |t|
      t.integer :table_id
      t.integer :comment_id

      t.timestamps null: false
    end
  end
end
