# encoding: utf-8
namespace :task_3625 do
  desc 'В таблице НН переименовать статус'
  # http://tasks.sloboda-studio.com/issues/3625
  # 0. Удалить статус interview
  # 1. Assigned meeting переименовать в Interview
  task :run => :environment do
    puts '*************************************'
    puts '======== START  TASK ========='

    interview = Status.where(:name => 'interview', :for_type => 'candidate').first
    assigned_meeting = Status.where(:name => 'assigned_meeting', :for_type => 'candidate').first

    if interview.nil? || assigned_meeting.nil?
      puts "Task was completed earlier"
    else
      Statistic.where(:status_id => interview.id).update_all(:status_id => assigned_meeting)

      Table.where(:status_id => interview.id).update_all(:status_id => assigned_meeting)

      connection = ActiveRecord::Base.establish_connection
      sql = "UPDATE tasks set status_id=#{assigned_meeting.id} where status_id= #{interview.id};"
      result = connection.connection.execute(sql)

      interview.destroy
      assigned_meeting.name = 'interview'
      assigned_meeting.save!
    end

    puts '======== FINISH TASK ========='
    puts '************************************'
  end
end
