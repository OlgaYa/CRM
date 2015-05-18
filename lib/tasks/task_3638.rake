# encoding: utf-8
namespace :task_3638 do
  desc 'Добавить горячесть лида от 1 до 10'
  # http://tasks.sloboda-studio.com/issues/3638
  task :run => :environment do
    puts '******************************'
    puts '======== START  TASK ========='

    new_statuses = [
      { name: '0 Declined', old_names: ['declined'] },
      { name: '1 ProbablyNo' },
      { name: '2 ReminderAfterNo' },
      { name: '3 Potential lead', old_names: ['potential lead'] },
      { name: '4 Interest', old_names: ['negotiations', 'wait for answer'] },
      { name: '5 Assigned meeting', old_names: ['assigned_meeting'] },
      { name: '6 Wait for requirement', old_names: ['wait for requirements'] },
      { name: '7 Qualifitcation' },
      { name: '8 Committed' },
      { name: '9 Test Job', old_names: ['do test job'] },
      { name: '10 Sold', old_names: ['sold'] }
    ]

    max_id = Status.maximum(:id)

    new_statuses.each do |status|
      status[:old_ids] = Status.where(for_type: 'sale').where(:name => status[:old_names]).map(&:id)
      if Status.where('for_type = ?', 'sale').find_by_name(status[:name]).nil?
        max_id += 1
        Status.new(id: max_id, name: status[:name], for_type: 'sale').save!
        status[:id] = max_id
        status[:old_ids].each do |id|
          Statistic.where(:status_id => id).update_all(:status_id => status[:id])
          Table.where(:status_id => id).update_all(:status_id => status[:id])
          connection = ActiveRecord::Base.establish_connection
          sql = "UPDATE tasks set status_id=#{status[:id]} where status_id= #{id};"
          result = connection.connection.execute(sql)
          Status.find(id).destroy
        end
      end
    end

    puts '======== FINISH TASK ========='
    puts '******************************'
  end
end
