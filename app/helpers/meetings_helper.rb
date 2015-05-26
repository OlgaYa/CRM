module MeetingsHelper
	def change_date(meeting)
    if @current_day != meeting.start_time.to_date
      @current_day = meeting.start_time.to_date
      if @current_day == Date.today
        "Today"
      else
        @current_day
      end
    end
	end

  def get_remove_link_meeting(path, id, field)
    link_to(image_tag('remove.png'), path,
            method: :delete)
  end
end
