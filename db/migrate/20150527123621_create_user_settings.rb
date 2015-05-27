class CreateUserSettings < ActiveRecord::Migration

  def up
    create_table :user_settings do |t|
      t.string :hh_record_per_page
      t.string :sale_record_per_page
      t.belongs_to :user
      t.timestamps null: false
    end
  end

  def down
    drop_table :user_settings
  end

end
