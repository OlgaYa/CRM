class MeetingsController < ApplicationController
	require 'rubygems'
	require 'google_calendar'

	def index
	end 


	def create
		@meeting = Meeting.new(meeting_params)
		if @meeting.save
			config = YAML.load(File.read(File.join(Rails.root, 'config', 'calendar.yml')))
			cal = Google::Calendar.new(:client_id     => config['client_id'], 
		                           :client_secret => config['client_secret'],
		                           :calendar      => config['calendar'],
		                           :redirect_url  => config['redirect_url'],
		                           :refresh_token => config['refresh_token'])

			event = cal.create_event do |e|
		    e.title = @meeting.title
		    e.description = @meeting.description
		    e.start_time = @meeting.start_time
		    e.end_time = @meeting.end_time
		    users = params[:users]
		    attendees = [{'email'=> current_user.email, 'displayName' => "#{current_user.first_name} #{current_user.last_name}", 'responseStatus' => 'tentative'}]
		    (users || []).each_index do |i|
		    	if users[i].include?("task")
		    		task = Sale.find_by_id(users[i].to_i)
		   			attendees[i+1] = {'email' => task.email, 'displayName' => task.name, 'responseStatus' => 'tentative'} if task.email
		    	else
			    	user = User.find_by_id(users[i].to_i)
			    	attendees[i+1] = {'email' => user.email, 'displayName' => "#{user.first_name} #{user.last_name}", 'responseStatus' => 'tentative'}
		    	end
		    end
		    attendees<<{'email'=> params[:@meeting][:email], 'displayName' => "Indefinite", 'responseStatus' => 'tentative'} unless params[:@meeting][:email].empty?
		    e.attendees = attendees
			end
			redirect_to root_url
		else
			redirect_to root_url
		end
	end
	def meeting_params
		params.require(:@meeting).permit(:title, :description, :start_time, :end_time)
	end
end