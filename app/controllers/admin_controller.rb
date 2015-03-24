class AdminController < ApplicationController
	def all_users
		@users = User.all.order(:created_at)
	end

  def banning_user
    
  end
end
