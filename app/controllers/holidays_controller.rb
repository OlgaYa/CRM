class HolidaysController < ApplicationController
  def index
    holidays = Holiday.all.pluck(:date, :title)
    @hash_holidays = {}
    @hash_holidays[:holidays] = []
    @hash_holidays["month"] = Holiday.find_all_hours_in_months
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
    @hash_holidays["month"] = Holiday.find_all_hours_in_months
    render layout: false
  end
end
