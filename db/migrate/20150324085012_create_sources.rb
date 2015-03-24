class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.timestamps null: false
    end
    remove_source_from_user
  end

  def remove_source_from_user
    remove_column :tasks, :source
  end
end
