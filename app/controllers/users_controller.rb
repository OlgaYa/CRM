class UsersController < ApplicationController
	skip_before_action :authenticate_user!, only: [:update]
	before_action :correct_user,   only: [:edit, :update, :update_info, :update_pass]
  
  def show
    @user = User.find(params[:id])
  end

  def edit
  	@user = User.find(params[:id])
  end

  # OPTIMIZE
  def update
    case params[:update]
    when 'update-pass'
      if @user.update_attributes(password: params[:user][:password], 
                                 password_confirmation: params[:user][:password_confirmation])
        user_successful_updatetd('pass')
      else
        render 'show'
      end
    when 'update-info'
      if @user.update_attributes(first_name: params[:user][:first_name], 
                                 last_name: params[:user][:last_name], 
                                 email: params[:user][:email], 
                                 avatar: params[:user][:avatar])
      
        user_successful_updatetd('info')
      else
        render 'show'
      end
    else
      if @user.update_attributes(user_params)
        user_successful_updatetd
      else
        render 'show'
      end      
    end
  end

  # OPTIMIZE
  def destroy
    user = User.find(params[:id])
    if user.sign_in_count == 0
      user.destroy
      flash[:success] = "User was successfully removed."
    else
      flash[:error] = "You can't remove this user"
    end
    redirect_to admin_show_users_path
  end

  def user_params
    params.require(:user).permit(:first_name, 
                                 :last_name, 
                                 :email, 
                                 :password,
                                 :password_confirmation, 
                                 :reseive_mails, 
                                 :receive_micropost_mails, 
                                 :avatar)
  end

  def correct_user
    user = User.find(params[:id])
    unless current_user == user
      redirect_to(root_url)
    else
      @user = user
    end
  end

  private
    def user_successful_updatetd(mess = "success")
      flash[:success] = mess
      sign_in @user, :bypass => true
      redirect_to @user
    end
end
