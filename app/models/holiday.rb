class Holiday < ActiveRecord::Base
  validates :date, presence: true, uniqueness: true

  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def self.find_all_hours_in_months
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
