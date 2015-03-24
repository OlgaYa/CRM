require 'rubygems'
require 'rufus/scheduler' 

 scheduler = Rufus::Scheduler.start_new

 scheduler.cron '0 9 * * 1-5' do
 # every day of the week at 9:00 
 	User.reminder
 end 

 # scheduler.every '30s' do
 # 	User.reminder
 # end

 # scheduler.every '30s' do
 # 	Message.check_mailing
 # end


 


