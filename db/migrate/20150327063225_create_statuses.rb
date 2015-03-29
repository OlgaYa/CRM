class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name

      t.timestamps null: false
    end
    add_column :tasks, :status_id, :integer
  end
end
