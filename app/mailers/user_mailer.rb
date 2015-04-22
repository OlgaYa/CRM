class UserMailer < ActionMailer::Base
	include ActionView::Helpers::SanitizeHelper
  # include Sidekiq::Mailer

  default :from => "crm.sloboda.studio@gmail.com"

  def new_password_instructions(user, admin)
    @user = user
    @admin = admin
    mail(:to => user.email, :subject => "Registered")
  end

  def new_assign_user_instructions(table, current_user, user_id)
    @user = User.find(user_id)
    @table_name = table.name
    @current_user = current_user
    subject = "TASK #{table.id}"
  	mail(:to => @user.email, :subject => subject )
  end

  def reminder_instructions(user_id, table_name)
  	@user = User.find_by_id(user_id)
    @table_name = table_name
    subject = "Reminder TASK"
  	mail(:to => @user.email, :subject => subject )
  end

  def remind_today(table_id)
    table = Table.find(table_id);
    @user = table.user
    @level = table.level.name if table.level
    @specialization = table.specialization.name if table.specialization
    @name = table.name
    subject = "[info] CRM-Reminder"
    mail(:to => @user.email, :subject => subject)
  end
end
