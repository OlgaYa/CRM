class CreateSimpleText < ActiveRecord::Migration
  def change
    create_table :simple_texts do |t|
    	    t.string   "name"
			    t.text     "text"
			    t.datetime "created_at"
			    t.datetime "updated_at"
    end
  end
end
