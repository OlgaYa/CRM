class StatisticsController < ApplicationController
	respond_to :json

	def index
	end

	def change_information
		hash = []
		inform = {}
		hash[1]=[]

		month = Task.connection.select_all("SELECT distinct date_trunc('month', updated_at) as day FROM tasks order by day asc")
				
		allusers = params[:user].empty? ? [""] : params[:user]
		allstatus = params[:status].empty?  ? [""] : params[:status]
		allsources = params[:source].empty?  ? [""] : params[:source]
		allsources.each do |x|
				allusers.each do |y|
					allstatus.each do |z|
						name = y.empty? ? "" : "#{User.find_by_id(y).first_name} #{User.find_by_id(y).last_name}"
						select = y.empty? ? "" : "where user_id = #{y}"
						if name.empty?
							name = x.empty? ? "" : Source.find_by_id(x).name
							select = x.empty? ? "" : "where source_id = #{x}"
						else
							name += x.empty? ? "" : ": #{Source.find_by_id(x).name}"
							select += x.empty? ? "" : " and source_id = #{x}"
						end
						if name.empty?
							name = z.empty? ? "" : Status.find_by_id(z).name
							select = z.empty? ? "" : "where status_id = #{z}"
						else
							name += z.empty? ? "" : ": #{Status.find_by_id(z).name}"
							select += z.empty? ? "" : " and status_id = #{z}"
						end
						name = "All" if name.empty?
						hash[1]<<get_information(name, select)
					end
				end
			end

		month.rows.flatten!.map!{ |x| x.to_date}
		hash[0] = month.rows
	 	month.rows.each_with_index do |v,i|
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