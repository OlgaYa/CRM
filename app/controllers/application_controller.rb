class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: [:home, :baned_user]
  before_action :check_user_status, except: [:baned_user, :home]

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :remember_me) }
  end

  def check_user_status
    if current_user && current_user.status == 'lock'
      redirect_to baned_user_path
    end
  end  
end
