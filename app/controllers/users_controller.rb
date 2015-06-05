class UsersController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: [:update]
  before_action :user_by_id, only: [:edit,
                                    :show,
                                    :update]
  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = params[:update]
      sign_in @user, bypass: true
      redirect_to @user
    else
      render 'show'
    end
  end

  # OPTIMIZE
  def destroy
    user = User.find(params[:id])
    if user.sign_in_count == 0
      user.destroy
      flash[:success] = 'User was successfully removed.'
    else
      flash[:error] = "You can't remove this user"
    end
    redirect_to admin_show_users_path
  end

  def remove_project
    begin
      user = User.find(params[:user_id])
      project = user.projects.find(params[:project_id])
      user.projects.delete(project)
    rescue
    ensure
      render json: 'success'.to_json
    end
  end

  private

    def user_by_id
      @user = User.find(params[:id])
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
end
