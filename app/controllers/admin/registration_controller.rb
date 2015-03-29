class Admin::RegistrationController < ApplicationController
	skip_before_action :authenticate_user!, only: [:update, :edit]

	include ApplicationHelper

	def create
		@user = User.new(user_params_create)
		@user.password = @user.password_confirmation = Array.new(8) { (rand(122-97) + 97).chr }.join
	    if @user.save
	    	@user.send_password_reset(current_user)
	    	get_tr
	    else
	      render json: @user.errors.full_messages.to_json 
	    end
	end

	def edit
		@user = User.find_by_reset_password_token(params[:id])
	  redirect_to root_url unless @user
	end

	def update
		@user = User.find_by_reset_password_token!(params[:id])
		if @user.reset_password_sent_at < 3.day.ago
			redirect_to root_url, :alert => "Password &crarr;  reset has expired."
		elsif @user.update_attributes(user_params_update)
			sign_in @user, :bypass => true
			redirect_to root_url, :notice => "Password has been reset."
		else
			render :edit
		end
	end

  def user_params_create
		params.require(:@user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :admin)
	end

	def user_params_update
		params.require(:user).permit(:password, :password_confirmation)
	end

	# Generating row of table "All users"
	def get_tr
		render html: generate_tr_for_user(@user).html_safe 
	end
end
