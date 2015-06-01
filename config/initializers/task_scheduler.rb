# encoding: utf-8
# TODO clear log
require 'rubygems'
require 'rufus/scheduler'

    FILE_NAME = "log/rufus_scheduler.log"

    unless File.exist?(FILE_NAME)
      File.new(FILE_NAME, "w+")
    end

    def write_log (s)
      File.open(FILE_NAME, 'a') { |file| file.write(s) }
    end

begin

  scheduler =  Rufus::Scheduler.new(:lockfile => '.rufus-scheduler.lock')

  scheduler.cron '0 9 * * 1-5' do
    # every day of the week at 9:00
    User.reminder
  end

  scheduler.cron '30 00 * * *' do
    User.contact_later_reminder
  end

  scheduler.cron '00 01 * * *' do
    write_log("Start #{Time.now.strftime("%H:%M:%S")} (start refresh DtReports - one day)\n")
    DtReport.refresh_day((1.day.ago).strftime('%Y-%m-%d'))
    write_log("Start #{Time.now.strftime("%H:%M:%S")} (finish refresh DtReports - one day)\n")
  end

  scheduler.cron('00 02 * * sun') do
    write_log("Start #{Time.now.strftime("%H:%M:%S")} (start refresh DtReports - one week)\n")
    DtReport.refresh_week((1.day.ago).strftime('%Y-%m-%d'))
    write_log("Start #{Time.now.strftime("%H:%M:%S")} (finish refresh DtReports - one week)\n")
  end

  scheduler.cron('00 03 1 * *') do
    write_log("Start #{Time.now.strftime("%H:%M:%S")} (start refresh DtReports - one month)\n")
    DtReport.refresh_month((1.day.ago).strftime('%Y-%m-%d'))
    write_log("Start #{Time.now.strftime("%H:%M:%S")} (finish refresh DtReports - one month)\n")
  end

  scheduler.cron '0 1 * * *' do
    write_log("Start #{Time.now.strftime("%H:%M:%S")} (check status '1 ProbablyNo')\n")
    status_old = Status.find_by_name('1 ProbablyNo')
    status_new = Status.find_by_name('2 ReminderAfterNo')
    rows = Table.where('status_id = ? AND date_status_1 <= ?', status_old.id, 2.week.ago.to_date).update_all(status_id: status_new.id, date_status_1: nil)
    write_log("\tRow count = #{rows}\n")
    write_log("Finish #{Time.now.strftime("%H:%M:%S")} (check status '1 ProbablyNo')\n\n")
  end

  # напоминалка об отчетах за прошлый день
  scheduler.cron '0 14 * * 2-6' do
    write_log("Start #{Time.now.strftime("%Y/%m/%d %a %H:%M:%S")} (report reminder)\n")
    users = User.reports_oblige_users
    users.each do |user|
      write_log("\tUser: #{user.name} | email: #{user.email}\n")
      if user.reports.where('date = ?', Date.today - 1).empty?
        write_log("\t\tОтчетов за вчера нет. Отправляем уведомление.\n")
        UserMailer.reminder_report(user.id).deliver
      else
        write_log("\t\tОтчеты за вчера есть. Не отправляем уведомление.\n")
      end
    end
    write_log("Finish #{Time.now.strftime("%Y/%m/%d %a %H:%M:%S")} (report reminder)\n\n")
  end

rescue Rufus::Scheduler::NotRunningError

end