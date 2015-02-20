class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
   def edit
     @user = User.where(reset_password_token: params[:reset_password_token])
   end

  # PUT /resource/password
   def update
      binding.pry
      @user = User.find_by(params[:id])
      if !@user#reset_password_sent_at < 8.hours.ago
    #   #redirect_to new_password_reset_path, :alert => "Password reset has expired."
     elsif
      @user.update_attributes(user_params)
      redirect_to @user, :notice => "Password has been reset!"
    else
      render :edit
    end
   end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
