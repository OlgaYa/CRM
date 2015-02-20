class Admin::RegistrationController < ApplicationController
	def new
		@new_user = User.new
	end

	def create
		@new_user = User.new(user_params)
	    if @new_user.save
	    	set_reset_password_token
	    	#token = set_reset_password_token
	    	UserMailer.registration_confirmation(@new_user, current_user).deliver
	    	redirect_to root_url	
	    else
	       render 'new'  
	    end
	end

    def user_params
		params.require(:@new_user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

	def set_reset_password_token
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      @new_user.reset_password_token   = enc
      @new_user.reset_password_sent_at = Time.now.utc
      @new_user.save
      raw
   end
end
