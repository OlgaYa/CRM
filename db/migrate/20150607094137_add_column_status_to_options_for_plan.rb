class AddColumnStatusToOptionsForPlan < ActiveRecord::Migration
  def change
    add_column :options_for_plans, :status, :string, default: "active"
  end
end
