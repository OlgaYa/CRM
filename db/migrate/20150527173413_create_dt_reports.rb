class CreateDtReports < ActiveRecord::Migration
  def change
    create_table :dt_reports do |t|
      t.date    :date
      t.integer :time
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
