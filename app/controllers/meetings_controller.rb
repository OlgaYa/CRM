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
		    attendees = []
		    users.each_index do |i|
		    	user = User.find_by_id(users[i].to_i)
		    	attendees[i] = {'email' => user.email, 'displayName' => "#{user.first_name} #{user.last_name}", 'responseStatus' => 'tentative'}
		    end
		    e.attendees = attendees
			end
			redirect_to root_url
			flash[:success] = "Meeting was successful add"
		else
			redirect_to root_url
			flash[:success] = "Something was wrong"
		end
	end
	def meeting_params
		params.require(:@meeting).permit(:title, :description, :start_time, :end_time)
	end
end