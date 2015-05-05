class AddColumnTableSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :table_settings, :string
  end
end
