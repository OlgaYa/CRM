class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name, unique: true
      t.string :description
      
      t.timestamps null: false
    end
  end
end
