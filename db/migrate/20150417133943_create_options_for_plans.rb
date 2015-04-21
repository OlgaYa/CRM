class CreateOptionsForPlans < ActiveRecord::Migration
  def change
    create_table :options_for_plans do |t|
    	t.integer  :plan_id
    	t.references :option, polymorphic: true
    end
  end
end
