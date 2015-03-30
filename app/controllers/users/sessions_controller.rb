class Users::SessionsController < Devise::SessionsController
  prepend_before_filter :check_user_status, only: :create
  prepend_before_filter :require_no_authentication, only: [:new, :create]
  prepend_before_filter :allow_params_authentication!, only: :create
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #     super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def check_user_status
    user = User.find_by(email: params[:user][:email])
    if user && user.status == 'lock'
      redirect_to baned_user_path
    end
  end
end
