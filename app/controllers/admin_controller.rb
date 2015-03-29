class AdminController < ApplicationController
	def show_users
    @users = User.all.order(:created_at)
	end

  def task_controls
    @statuses = Status.all
    @sources = Source.all
  end

  def banning_user
  end

  def create_source
    @source = Source.create(params[:source])
    # render html: 
  end

  def update_source
    
  end

  def destroy_source
  end

  def create_status
    @status = Status.create(params[:status])
    # render html: 
  end

  def update_status
  end

  def destroy_status
  end
end
