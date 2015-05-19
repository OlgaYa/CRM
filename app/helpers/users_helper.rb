module UsersHelper

  def info_errors(user)
    return false if user.errors.messages.blank?
    if user.errors.messages[:first_name] || user.errors.messages[:last_name] || user.errors.messages[:email]
      true
    else
      false
    end
  end

  def pass_errors(user)
    return false if user.errors.messages.blank?
    if user.errors.messages[:password] || user.errors.messages[:password_confirmation]
      true
    else
      false
    end
  end

  def get_user_info(user_id)
    user = User.find(user_id)
    @first_name = user.first_name
    @last_name = user.last_name
    @email = user.email
  end
end
