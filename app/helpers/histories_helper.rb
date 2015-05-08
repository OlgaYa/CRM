module HistoriesHelper
  NOT_MODAL = ["Name", "Lead"]

  def information_about_change(options)
    if options
      key = options.history_option_type
      value = if NOT_MODAL.include?(key)
                options.history_option_id
              else
                key == "Name"? options.history_option.full_name : options.history_option.name 
              end
      "Change #{key} to #{value}"
    else
      "Create a new task"
    end
  end

  def change_date(history)
    history.created_at.to_date == @current_day? "today" : history.created_at.to_date
  end
end
