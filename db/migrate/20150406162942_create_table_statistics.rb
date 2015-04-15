class CreateTableStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
    	t.integer  :statistic_id
      t.string   :for_type
      t.integer  :level_id
      t.integer  :specialization_id
      t.integer  :source_id
      t.date     :week
      t.integer  :status_id
      t.integer  :user_id
      t.integer  :count, default: 1
      
    end
  end
end
