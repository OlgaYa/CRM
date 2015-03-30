class StaticPagesController < ApplicationController
	def home
		redirect_to tasks_path if (current_user && (current_user.status != 'lock'))
  end

  def baned_user
  end
end
