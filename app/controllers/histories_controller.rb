class HistoriesController < ApplicationController
	def  index
		@histories = History.all.order(created_at: :desc)
		@current_day = Date.today - 1.days
	end
end
