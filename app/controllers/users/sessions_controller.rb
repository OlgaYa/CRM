class Users::SessionsController < Devise::SessionsController
  prepend_before_filter :check_user_status, only: :create
  prepend_before_filter :require_no_authentication, only: [:new, :create]
  prepend_before_filter :allow_params_authentication!, only: :create
  skip_before_action :check_user_status, only: :destroy
  
  def check_user_status
    user = User.find_by(email: params[:user][:email])
    if user && user.locked?
      redirect_to baned_user_path
    end
  end
end
