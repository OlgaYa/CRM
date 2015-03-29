class AdminController < ApplicationController
	def show_users
    @users = User.all.order(:created_at)
	end

  def task_controls
    @statuses = Status.all.order('created_at')
    @sources = Source.all.order('created_at')
  end

  def banning_user
  end

  def create_source
    @source = Source.create(name: params[:name])
  end

  def update_source
    Source.find(params[:id]).update_attribute(params[:field].to_s, params[:value])
    resp = "success".to_json
    render :json => resp  
  end

  def destroy_source
    unless Task.exists?(source_id: params[:id])
      Source.find(params[:id]).destroy
    end
  end

  def create_status
    @status = Status.create(name: params[:name])
  end

  def update_status
    Status.find(params[:id]).update_attribute(params[:field].to_s, params[:value])
    resp = "success".to_json
    render :json => resp  
  end

  def destroy_status
    unless Task.exists?(status_id: params[:id])
      Status.find(params[:id]).destroy
    end
  end
end
