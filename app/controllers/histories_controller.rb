class HistoriesController < ApplicationController
	def  index
		@histories = History.all.order(created_at: :desc)
		@current_day = Date.today
		@previous_day = Date.today
	end
end