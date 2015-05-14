# encoding: utf-8
namespace :task_3637 do
  desc 'Интеграция с MailChimp'
  # http://tasks.sloboda-studio.com/issues/3637
  # Нужно:
  # 1. Создать списки для рассылки:
  # - Potential clients
  # - Potential Ror
  # - Potential Switchers
  # - Junes
  # - Other
  # 2. При добавлении нового контакта:
  # - в таблицу заказов, если заполнено поле email - сразу добавить в MailChimp этого заказчика, в таблицу потенциальных клиентов
  # - в таблицу НН со специализацией Ror и уровнем junior - сразу добавить в MailChimp этого разработчика, в соответствующую таблицу
  # - и тд.
  # 3. Импортировать из текущей базы в соответствующем виде все задачи.
  task :run => :environment do
    puts '******************************'
    puts '======== START  TASK ========='

    rows = Table.all
    rows.each do |row|
      p "ID = #{row.id} | Email = #{row.email}"
      row.add_email_to_mailchimp if ['Sale','Candidate'].include?(row.type)
    end

    puts '======== FINISH TASK ========='
    puts '******************************'
  end
end
