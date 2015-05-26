# TODO clear log
require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new

FILE_NAME = "log/rufus_scheduler.log"

unless File.exist?(FILE_NAME)
  File.new(FILE_NAME, "w+")
end

def write_log (s)
  File.open(FILE_NAME, 'a') { |file| file.write(s) }
end

scheduler.cron '0 9 * * 1-5' do
# every day of the week at 9:00
  User.reminder
end

scheduler.cron '30 00 * * *' do
  User.contact_later_reminder
end

scheduler.cron '0 1 * * *' do
  write_log("Start #{Time.now.strftime("%H:%M:%S")} (check status '1 ProbablyNo')\n")
  status_old = Status.find_by_name('1 ProbablyNo')
  status_new = Status.find_by_name('2 ReminderAfterNo')
  rows = Table.where('status_id = ? AND date_status_1 <= ?', status_old.id, 2.week.ago.to_date).update_all(status_id: status_new.id, date_status_1: nil)
  write_log("\tRow count = #{rows}\n")
  write_log("Finish #{Time.now.strftime("%H:%M:%S")} (check status '1 ProbablyNo')\n\n")
end
