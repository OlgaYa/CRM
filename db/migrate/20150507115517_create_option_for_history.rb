class CreateOptionForHistory < ActiveRecord::Migration
  def change
    create_table :options_for_histories do |t|
    	t.integer  		:history_id
    	t.references 	:history_option, polymorphic: true
    end
  end
end
