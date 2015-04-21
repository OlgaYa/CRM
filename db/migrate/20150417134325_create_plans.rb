class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
    	t.date     :date_from
      t.date 		 :date_to
    	t.string 	 :for_type, 	default: 'sale'
    	t.integer  :count, 			default: 0
    	t.integer  :percentage, default: 0
    end
  end
end
