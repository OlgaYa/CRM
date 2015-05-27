class HolidaysController < ApplicationController
  def index
    holidays = Holiday.all.pluck(:date, :title)
    @hash_holidays = {}
    @hash_holidays[:holidays] = []
    @hash_holidays["month"] = find_all_hours_in_months
    holidays.each do |holiday|
      item = {}
      item["title"] = holiday[1]
      item["start"]  = holiday[0]
      @hash_holidays[:holidays] << item
    end
    @hash_holidays.to_json
  end

  def update_list_events
    case params[:status]
    when "add"
      holiday = Holiday.create(date:  params[:date],
                               title: params[:title])
    when "destroy"
      holiday = Holiday.where(date: params[:date])
      Holiday.delete(holiday)
    end
    @hash_holidays = {}
    @hash_holidays["month"] = find_all_hours_in_months
    render layout: false
  end

  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def find_all_hours_in_months
    months = []
    array_holiday = Holiday.all.pluck(:date)
    1.upto(12) do |i|
      count_days = days_in_month(i)
      count_days -= array_holiday.select{|item| item.month == i}.count
      months[i] = count_days*8
    end
    months
  end

  def days_in_month(month, year = Time.now.year)
     return 29 if month == 2 && Date.gregorian_leap?(year)
     COMMON_YEAR_DAYS_IN_MONTH[month]
  end
end
