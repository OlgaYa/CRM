class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: [:home, :baned_user]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name,
               :last_name,
               :email,
               :password,
               :password_confirmation,
               :remember_me)
    end
  end

  unless Rails.env.development?
    rescue_from Exception do |exception|
      redirect_to root_path
    end
  end

end
