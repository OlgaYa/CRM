module HistoriesHelper
  NOT_MODEL = ["Name", "Lead", "Email", "Skype", "Topic"]

  def information_about_change(history)
    options = history.options_for_history.first
    if options
      key = options.history_option_type
      value = if NOT_MODEL.include?(key)
                history.description
              else
                case key
                when "Name"
                  options.history_option.full_name
                when "Comment"
                  options.history_option.body
                when "Link"
                  options.history_option.href
                else
                  options.history_option.name
                end
              end
      "#{key}: #{value}"
    else
      "Create a new task"
    end
  end

  def change_date(history)
    if @current_day != history.created_at.to_date
      @current_day = history.created_at.to_date
      if @current_day == Date.today
        "Today"
      else
        @current_day
      end
    end
  end
end
