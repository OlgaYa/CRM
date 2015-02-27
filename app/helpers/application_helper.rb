module ApplicationHelper

	def get_count_tasks(only = "")
		case only 
	    when 'sold'
	      Task.all.where("status = 'sold'").count.to_s
	    when 'declined'
	      Task.all.where("status = 'declined'").count.to_s
	    else
	      Task.all.where("status != 'sold' AND status != 'declined' OR status IS NULL").count.to_s
	    end
	end
end
