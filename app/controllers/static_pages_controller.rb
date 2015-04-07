class StaticPagesController < ApplicationController
	def home
    if current_user
      if current_user.admin? || current_user.role == 'seller'
  		  redirect_to tables_path(type: 'SALE')
      else
        redirect_to tables_path(type: 'CANDIDATE')
      end
    end
  end

  def baned_user
  end
end
