class UsersController < ApplicationController
	skip_before_action :authenticate_user!, only: [:update]
	before_action :correct_user,   only: [:edit, :update]
  # def index
  #   @users = User.paginate(page: params[:page])
  # end

  def show
    @user = User.find(params[:id])
  end

  def edit
  	@user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user, :bypass => true
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :reseive_mails, :receive_micropost_mails)
  end

  def correct_user
    user = User.find(params[:id])
    redirect_to(root_url) unless current_user == user
  end
end
