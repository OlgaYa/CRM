class TasksController < ApplicationController 
  
  include ApplicationHelper

  def index
    if Status.exists?(name: params[:only])
      @tasks = Task.join_statuses.where("statuses.name = ?", params[:only])
    else
      @tasks = Task.join_statuses.where_status_not_sold_or_declined   
    end
    paginate_tasks       
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path
    else
      render 'new'
    end
  end

  def destroy
    if Task.find(params[:id]).destroy
      flash[:success] = "Task was successful deleted"
    else
      flash[:error] = "Task was not deleted"
    end
    redirect_to :back
  end

  def update
    task = Task.find(params[:id])
    unless ['topic', 'source_id', 'name'].include? params[:field]   
      task.update_attribute(:date, Date.current())
    end
    if params[:field] == 'status_id'
      task.update_attribute(params[:field].to_sym, params[:value])
      if Status.find(params[:value]).name == 'sold'
        sold_task = current_user.sold_tasks.create(task_id: task.id)
        task.sold_task = sold_task
      elsif SoldTask.exists?(task_id: task.id)
        sold_task = current_user.sold_tasks.find_by(task_id: task.id)
        time = DateTime.now
        comment = "Price: #{sold_task.price} Terms: #{sold_task.date_start} - #{sold_task.date_end}"
        task.comments.create(user_id: current_user.id , body: comment, datetime: time)
        sold_task.destroy 
      end 
    else
      if (params[:field] == "user_id" and params[:value] != "")
        if current_user.id != params[:value].to_i
          UserMailer.new_assign_user_instructions(task, current_user, params[:value]).deliver
        end
      end
      task.update_attribute(params[:field].to_sym, params[:value])
    end  
    resp = "success".to_json
    render :json => resp  
  end

  def export
  end

  def download_xls
    tasks = Task.join_statuses
    tasks = tasks.where("tasks.created_at > '#{params[:period][:from]}'") if !params[:period]["from"].empty?
    tasks = tasks.where("tasks.created_at < '#{params[:period][:to]}'") if !params[:period]["to"].empty?
    file_name = 'custom tasks'
    if params[:export]
      case params[:export]
      when 'sold'
        tasks = tasks.where('statuses.name = ?', :sold)
        file_name = 'sold tasks'
      when 'open'
        tasks = tasks.where_status_not_sold_or_declined
        file_name = 'open tasks'
      when 'declined'
        tasks = tasks.where('statuses.name = ?', :declined)
        file_name = 'declined tasks'
      else
        file_name = 'all tasks'
      end
      send_data(tasks.to_csv(col_sep: "\t"), filename: file_name + ".xls")
    else
      if params[:fields]
        tasks = tasks.where(:status => params[:statuses]) if params[:statuses]
        tasks = tasks.where(:user_id => params[:users]) if params[:users]
        send_data(tasks.to_csv({ col_sep: "\t" }, params[:fields]), filename: file_name + ".xls")
      else
        flash[:error] = "Fields can't be empty!"
        render "export"
      end
    end 
  end

  def create_link
    link = Link.create(task_id: params[:task_id] , alt: params[:alt], href: params[:href])  
    render html: generate_link(link).html_safe
  end

  def destroy_link
    Link.find(params[:id]).destroy
  end 

  private

    def task_params
      params[:task][:user_id] = current_user.id
      params.require(:task).permit(:name, :source, :skype, :email, :links, :date, :user_id, :status, :comments)
    end

    def paginate_tasks
      @tasks = @tasks.paginate(:page => params[:page], :per_page => 10).order('id DESC').by_date
    end
end