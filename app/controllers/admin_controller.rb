class AdminController < ApplicationController
	def show_users
    case params[:status]
    when 'lock'
      @users = User.all.where(status: :lock).order(:created_at)
    else
      @users = User.all.where(status: :unlock).order(:created_at)
    end
	end

  def task_controls
    @statuses = Status.all.order('created_at')
    @sources = Source.all.order('created_at')
  end

  def update_user_status
    user = User.find(params[:id])
    if user == current_user
      resp = "You can't ban yourself!".to_json
      render json: resp
    else 
      user.update_attribute(params[:field], params[:value])
      resp = "success".to_json
      render json: resp
    end
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
