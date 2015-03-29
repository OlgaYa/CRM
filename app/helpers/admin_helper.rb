module AdminHelper

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

	def get_edit_link(path)
		link_to(image_tag('edit.png'), path)
	end

	def get_remove_link(path, id, field)
		unless Task.exists?({field => id})
			link_to(image_tag('remove.png'), path, 
	                      method: :delete, remote: true)
		else
			image_tag('forbidden-icon.png', alt: "You can't remove it")
		end
	end
end
