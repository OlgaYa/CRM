class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string :name, default: :missing, unique: true
      t.string :level, default: :missing
      t.string :specialization, default: :missing
      t.string :email, default: :missing
      t.string :source, default: :missing
      t.string :date, default: :missing
      t.string :comment, default: :missing
      t.string :status, default: :missing
      t.string :topic, default: :missing
      t.string :skype, default: :missing
      t.string :message, default: :missing
      t.string :link, default: :missing
      t.string :assign_to, default: :missing

      t.timestamps null: false
    end
  end
end
