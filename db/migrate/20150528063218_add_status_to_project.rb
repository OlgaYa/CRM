class AddStatusToProject < ActiveRecord::Migration
  def change
    add_column :projects, :status, :string, default: "active"
    add_column :projects, :kind,   :string
  end
end
