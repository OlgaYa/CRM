require 'rubygems'
require 'rufus/scheduler' 

scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 9 * * 1-5' do
# every day of the week at 9:00 
	User.reminder
end 

scheduler.cron '25 02 * * *' do
  User.contact_later_reminder
end 
