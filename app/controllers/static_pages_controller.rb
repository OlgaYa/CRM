class StaticPagesController < ApplicationController
	def home
    if current_user
      case current_user.role
      when 'seller'
    	  redirect_to tables_path(type: 'SALE')
      when 'hh'
        redirect_to tables_path(type: 'CANDIDATE')
      when 'hr'
      end
    end
  end

  def baned_user
  end
end
