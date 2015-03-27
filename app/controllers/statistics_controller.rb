class StatisticsController < ApplicationController
	respond_to :json

	def index
	end

	def change_information
		hash = []
		inform = {}
		hash[1]=[]
		allusers = params[:user]
		allstatus = params[:status]
		allsources = params[:source]
		days = Task.connection.select_all("SELECT distinct date_trunc('month', updated_at) as day FROM tasks order by day asc")
		if allusers.empty? && allstatus.empty? && allsources.empty?
			hash[1]<<get_information("All", "")
		elsif allstatus.empty? && allsources.empty?
			allusers.each do |x|
				user = User.find_by_id(x)
				hash[1]<<get_information("#{user.first_name} #{user.last_name}", "where user_id = #{x}")
			end
		elsif allusers.empty? && allsources.empty?
			allstatus.each do |x|
				status = Status.find_by_id(x)
				hash[1]<<get_information(status.name,"where status_id = '#{x}'")
			end
		elsif allusers.empty? && allstatus.empty? 
			allsources.each do |x|
				source = Source.find_by_id(x)
				hash[1]<<get_information(source.name, "where source_id = '#{x}'")
			end
		elsif allusers.empty?
			allstatus.each do |x|
				allsources.each do |y|
					source = Source.find_by_id(y)
					status = Status.find_by_id(x)
					hash[1]<<get_information("#{source.name}: #{status.name}", "where status_id = '#{x}' and source_id = #{y}")
				end
			end
		elsif allsources.empty?
			allstatus.each do |x|
				allusers.each do |y|
					status = Status.find_by_id(x)
					user = User.find_by_id(y)
					hash[1]<<get_information("#{user.first_name} #{user.last_name}: #{status.name}","where status_id = '#{x}' and user_id = #{y}")
				end
			end
		elsif allstatus.empty?
			allsources.each do |x|
				allusers.each do |y|
					user = User.find_by_id(y)
					source = Source.find_by_id(x)
					hash[1]<<get_information("#{user.first_name} #{user.last_name}: #{source.name}","where source_id = '#{x}' and user_id = #{y}")
				end
			end
		else
			allsources.each do |x|
				allusers.each do |y|
					allstatus.each do |z|
						user = User.find_by_id(y)
						source = Source.find_by_id(x)
						status = Status.find_by_id(z)
						hash[1]<<get_information("#{user.first_name} #{user.last_name}: #{source.name}: #{status.name}","where source_id = '#{x}' and user_id = #{y} and status_id='#{z}'")
					end
				end
			end
		end
		days.rows.flatten!.map!{ |x| x.to_date}
		hash[0] = days.rows
	 	days.rows.each_with_index do |v,i|
	 		hash[1].each do |h|
		 		h[:data][i] = [v,0] unless h[:data][i]
		 			
		 		h[:data].insert(i, [v,0]) if h[:data][i][0] != v 
	 		end
	 	end	
		render :json => hash.to_json
	end

	def get_information(name, string)
		inform = {}
		inform[:name] = name
		inform[:data] = find_in_database(string)
		inform
	end

	def find_in_database(string)
		task = Task.connection.select_all("SELECT  date_trunc('month', updated_at) as day, count(id) FROM tasks #{string} group by day order by day asc")
		task.rows.map! do|x| 
			x.each_with_index do |v, i|
				x[i] = i.zero? ? v.to_date : v.to_i
			end
		end
		task.rows
	end
end