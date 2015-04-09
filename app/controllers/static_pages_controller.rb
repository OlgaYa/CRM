class StaticPagesController < ApplicationController
	def home
    if current_user || current_user.seller?
  	  redirect_to tables_path(type: 'SALE')
    else
      redirect_to tables_path(type: 'CANDIDATE')
    end
  end

  def baned_user
  end
end
