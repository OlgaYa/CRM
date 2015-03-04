class StatisticsController < ApplicationController
	def index
		@fromDate  = '2015-03-02'
		@toDate = Date.today
		@allcountTask = Task.all.count
		@countTask = Task.all.count
	end

	def change_information
		if params[:user] == ""
			countTask = Task.where("status = ?", params[:status]).count
		elsif params[:status] == ""
			countTask = Task.where("user_id = ?", params[:user]).count	
		else
			countTask = Task.where("status = ? and user_id = ?", params[:status], params[:user]).count
		end
		render html: "#{countTask}"
		# (#{countTask/@allcountTask*100}%)
	end
end