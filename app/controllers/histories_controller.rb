class HistoriesController < ApplicationController
	def  index
		@type = params[:type]
		@histories = History.where(for_type: @type.capitalize).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
		@current_day = Date.today - 1.days
	end
end
