module TasksHelper
	def all_users
		User.all.order(:created_at)
	end
end
