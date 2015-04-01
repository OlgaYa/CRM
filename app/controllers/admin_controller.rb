class AdminController < ApplicationController

  UNCHANGEABLESTATUS = ['sold', 'declined', 'negotiations', 'assigned_meeting']

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
    else 
      user.update_attribute(params[:field], params[:value])
      resp = "success".to_json
    end
      render json: resp
  end

  def create_source
    @source = Source.new(name: params[:name].downcase)
    unless @source.save
      @errors = @source.errors.full_messages
    end
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
    @status = Status.new(name: params[:name].downcase)
    unless @status.save
      @errors = @status.errors.full_messages
    end
  end

  def update_status
    status = Status.find(params[:id])
    if UNCHANGEABLESTATUS.include? status.name
      resp = "Sorry but you can't destroy this status".to_json
    else
      status.update_attribute(params[:field].to_s, params[:value])
      resp = "Success".to_json
    end
    render :json => resp  
  end

  def destroy_status
    status = Status.find(params[:id])
    unless Task.exists?(status_id: params[:id])
      unless UNCHANGEABLESTATUS.include? status.name
        status.destroy
      end
    end
  end
end
