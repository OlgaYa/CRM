class StatisticsController < ApplicationController
	respond_to :json

	def index
	end

	def change_information
		allTask = Task.all
		user = User.find_by_id(params[:user])
		days = Task.connection.select_all("SELECT distinct date_trunc('day', updated_at) as day FROM tasks order by day asc")
		if params[:user] == "" &&  params[:status] == ""
			task = Task.connection.select_all("SELECT date_trunc('day', updated_at)  as day, count(id) FROM tasks group by day  order by day asc")		
			name = "All"
		elsif params[:user] == ""
			#countTask = Task.where("status = ?", params[:status]).count
			task = Task.connection.select_all("SELECT  date_trunc('day', updated_at) as day, count(id) FROM tasks where status = '#{params[:status]}' group by day order by day asc")
			name = params[:status]
		elsif params[:status] == ""
			task = Task.connection.select_all("SELECT  date_trunc('day', updated_at) as day, count(id) FROM tasks where user_id = '#{params[:user]}' group by day order by day asc")
			#countTask = Task.where("user_id = ?", params[:user]).count	
			name = user.first_name + " " + user.last_name
		else
			task = Task.connection.select_all("SELECT  date_trunc('day', updated_at) as day, count(id) FROM tasks where status = '#{params[:status]}' and user_id = '#{params[:user]}' group by day order by day asc")
			#countTask = Task.where("status = ? and user_id = ?", params[:status], params[:user]).count
			name = params[:status].to_s + ": " + user.first_name + " " + user.last_name
		end
		hash = []
		days.rows.each_index{|d| days.rows[d][0] = days.rows[d][0].to_date}
		task.rows.each_index{|t| task.rows[t][0] =  task.rows[t][0].to_date}
		days.rows.each_index{|t| 
			if t < task.rows.count and task.rows[t][0] == days.rows[t][0]
				task.rows[t][1] = task.rows[t][1].to_i
			else
				task.rows.insert(t, [days.rows[t][0], 0])
			end
		}
		hash[0] = days.rows.flatten
	   	hash[1] =  [{name: name, data: task.rows }]	 
		render :json => hash.to_json
	end
end