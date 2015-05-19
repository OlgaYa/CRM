class CreateHistory < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer  :table_id
      t.integer  :user_id
      t.string   :for_type, default: 'sale'
      t.string   :description

      t.timestamps null: false
    end
  end
end
