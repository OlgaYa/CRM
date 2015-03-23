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

	def user_status(user)
		if user.admin?
			return 'Admin'
		else
			return 'User'
		end
	end

	def current_user?(user)
		user == current_user
	end
end
