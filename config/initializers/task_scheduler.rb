require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 9 * * 1-5' do
# every day of the week at 9:00
	User.reminder
end

scheduler.cron '30 00 * * *' do
  User.contact_later_reminder
end

scheduler.cron '0 1 * * *' do
  status_old = Status.find_by_name('1 ProbablyNo')
  status_new = Status.find_by_name('2 ReminderAfterNo')
  rows = Table.where(status: status_old).where('date_status_1 <= ?', 2.week.ago.to_date).update_all(status_id: status_new.id, date_status_1: nil)
end