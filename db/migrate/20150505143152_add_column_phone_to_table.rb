class AddColumnPhoneToTable < ActiveRecord::Migration
  def change
    add_column :tables, :phone, :string
  end
end
