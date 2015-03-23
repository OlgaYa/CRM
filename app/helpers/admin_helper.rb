module AdminHelper
	
	# def user_activity_status(user)
	# 	if user.current_sign_in_at
	# 		time = user.current_sign_in_at - DateTime.current
	# 		if time < -172800 
	# 			return 'danger'
	# 		elsif time < -86400 and time > -172800
	# 			return 'warning'
	# 		end
	# 	else
	# 		return 'danger'
	# 	end
	# end

	def get_new_user(user)
		if user
			user
		else
			User.new
		end
	end

	def get_users_control(user)
		if user.sign_in_count == 0 
			link_to(image_tag('remove.png'), user, data: {
          confirm: "Are you sure to remove user #{user.first_name} #{user.last_name}?"
        }, 
        method: :delete )
		else
			link_to(image_tag('edit.png'), user_path(user) + '#settings')
		end
	end
end
