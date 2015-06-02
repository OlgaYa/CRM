# == Schema Information
#
# Table name: dt_reports
#
#  id         :integer          not null, primary key
#  date       :date
#  time       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DtReport < ActiveRecord::Base
  belongs_to :user

  def self.refresh_day(date)
    desktime = DeskTime.new
    desktime_employees = desktime.employees(date)
    User.reports_oblige_users.each do |user|
      user_time = desktime.user_time(desktime_employees, user.email.downcase)
      dt_report = DtReport.find_or_initialize_by(user_id: user.id, date: date)
      dt_report.update_attributes(user_id: user.id,
                                  time: user_time,
                                  date: date) if user_time
    end
  end

  def self.refresh_week(date)
    date = date.to_date
    (date.at_beginning_of_week..date.end_of_week).each do |d|
      refresh_day(d)
    end
  end

  def self.refresh_month(date)
    date = date.to_date
    (date.at_beginning_of_month..date.end_of_month).each do |d|
      refresh_day(d)
    end
  end
end
