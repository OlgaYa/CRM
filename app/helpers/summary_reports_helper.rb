module SummaryReportsHelper

  def percent_time(t)
    if @working_hours && !@working_hours.zero?
      ((t / @working_hours) * 100.0).round(2)
    else
      nil
    end
  end

end
