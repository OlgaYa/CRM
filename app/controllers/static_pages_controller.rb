class StaticPagesController < ApplicationController
	def home
		redirect_to tasks_path if current_user
	end
end
