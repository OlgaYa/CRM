module AdminHelper
	def user_activity_status(user)
		if user.current_sign_in_at
			time = user.current_sign_in_at - DateTime.current
			if time < -172800 
				return 'danger'
			elsif time < -86400 and time > -172800
				return 'warning'
			end
		else
			return 'danger'
		end
	end

	def get_new_user(user)
		if user
			user
		else
			User.new
		end
	end
end
