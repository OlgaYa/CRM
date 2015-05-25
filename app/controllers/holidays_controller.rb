class HolidaysController < ApplicationController
  def index
    holidays = Holiday.all.pluck(:date, :title)
    @hash_holidays = {}
    @hash_holidays[:holidays] = []
    @hash_holidays["month"] = []
    holidays.each do |holiday|
      item = {}
      item["title"] = holiday[1]
      item["start"]  = holiday[0]
      @hash_holidays[:holidays] << item
    end
    array_holiday = Holiday.all.pluck(:date)
    1.upto(12) do |i|
      count_days = days_in_month(i)
      # array_holiday.select{|item| item.month == i}
      count_days -= array_holiday.select{|item| item.month == i}.count
      @hash_holidays["month"][i] = count_days*8
    end
    @hash_holidays.to_json
  end

  def update_list_events
    holiday = Holiday.new
    holiday.date = params[:date]
    holiday.title = params[:title]
    unless holiday.save
      holiday = Holiday.where(date: params[:date])
      Holiday.delete(holiday)
    else
      @hash_holidays = []
      array_holiday = Holiday.all.pluck(:date)
      1.upto(12) do |i|
        count_days = days_in_month(i)
        # array_holiday.select{|item| item.month == i}
        count_days -= array_holiday.select{|item| item.month == i}.count
        @hash_holidays[i] = count_days*8
      end
      # holidays = Holiday.all.pluck(:date, :title)
      # hash_holidays = []
      # holidays.each do |holiday|
      #   item = {}
      #   item["title"] = holiday[1]
      #   item["start"]  = holiday[0]
      #   hash_holidays << item
      # end
      # hash_holidays.to_json
      # render json:  @hash_holidays
      render layout: false
    end
  end

  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def days_in_month(month, year = Time.now.year)
     return 29 if month == 2 && Date.gregorian_leap?(year)
     COMMON_YEAR_DAYS_IN_MONTH[month]
  end
end
