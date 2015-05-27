class AdminController < ApplicationController
  authorize_resource class: false
  
  def admin_pointer
    permissions = current_user.permissions.pluck(:name)
    if permissions.include? 'hr_admin'
      redirect_to admin_show_users_path(status: 'unlock')
    elsif permissions.include? 'crm_controls_admin'
      redirect_to admin_show_users_path(status: 'unlock')
    elsif permissions.include? 'manage_hh_controls'
      redirect_to admin_task_controls_path(type: 'CANDIDATE')
    elsif permissions.include? 'manage_seller_controls'
      redirect_to admin_task_controls_path(type: 'SALE')
    end
  end

  def show_users
    case params[:status]
    when 'lock'
      @users = User.all_lock.order(:created_at)
    else
      @users = User.all_unlock.order(:created_at)
    end
  end

  def task_controls
    @statuses = Status.all.order('created_at')
    @sources = Source.all.order('created_at')
    @specializations = Specialization.all.order('created_at')
    @levels = Level.all.order('created_at')
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
    @source = Source.new(name: params[:name].downcase,
                         for_type: params[:for_type])
    unless @source.save
      @errors = @source.errors.full_messages
    end
  end

  def update_source
    Source.find(params[:id]).update_attribute(params[:field].to_s,
                                              params[:value])
    render json: 'success'.to_json
  end

  def destroy_source
    unless Table.exists?(source_id: params[:id])
      Source.find(params[:id]).destroy
    end
  end

  def create_status
    @status = Status.new(name: params[:name].downcase,
                         for_type: params[:for_type])
    unless @status.save
      @errors = @status.errors.full_messages
    end
  end

  def update_status
    status = Status.find(params[:id])
    if status.unchengeble_satus?
      resp = "Sorry but you can't destroy this status".to_json
    else
      status.update_attribute(params[:field].to_s, params[:value])
      resp = 'Success'.to_json
    end
    render json: resp
  end

  def destroy_status
    status = Status.find(params[:id])
    unless Table.exists?(status_id: params[:id])
      unless status.unchengeble_satus?
        status.destroy
      end
    end
  end

  def create_specialization
    @specialization = Specialization.new(name: params[:name].downcase)
    unless @specialization.save
      @errors = @specialization.errors.full_messages
    end
  end

  def update_specialization
    Specialization.find(params[:id]).update_attribute(params[:field].to_s,
                                                      params[:value])
    render json: 'success'.to_json
  end

  def destroy_specialization
    unless Table.exists?(specialization_id: params[:id])
      Specialization.find(params[:id]).destroy
    end
  end

  def create_level
    @level = Level.new(name: params[:name].downcase)
    unless @level.save
      @errors = @level.errors.full_messages
    end
  end

  def update_level
    Level.find(params[:id]).update_attribute(params[:field].to_s,
                                             params[:value])
    render json: "success".to_json
  end

  def destroy_level
    unless Table.exists?(level_id: params[:id])
      Level.find(params[:id]).destroy
    end
  end

  def controls
  end
end
