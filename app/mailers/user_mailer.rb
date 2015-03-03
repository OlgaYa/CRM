class UserMailer < ActionMailer::Base
	include ActionView::Helpers::SanitizeHelper

  default :from => "crm.sloboda.studio@gmail.com"
  
  def new_password_instructions(user, admin)
    @user = user
    @admin = admin
    mail(:to => user.email, :subject => "Registered")
  end

  def new_assign_user_instructions(task, current_user, user_id)
  	@user = User.find(user_id)
  	@task_name = strip_tags(task.name)
  	@current_user = current_user
  	mail(:to => @user.email, :subject => "New task")
  end

  def reminder_instructions(task)
  	@task_name = strip_tags(task.name)
  	@user = task.user
  	mail(:to => @user.email, :subject => "Reminder task")
  end
end
