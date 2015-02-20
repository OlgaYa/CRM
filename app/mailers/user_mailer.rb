class UserMailer < ActionMailer::Base
	default :from => "avopop.a.c@gmail.com"
  
  def registration_confirmation(user, author)
    @user = user
    @author = author
    mail(:to => user.email, :subject => "Registered")
  end
end
