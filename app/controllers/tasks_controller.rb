class TasksController < ApplicationController 
  
  def index
    case params[:only] 
    when 'sold'
      @tasks = Task.all.where("status = 'sold'").order("created_at DESC")
      filename = 'sold'
    when 'declined'
      @tasks = Task.all.where("status = 'declined'").order("created_at DESC")
      filename = 'declined'
    else
      @tasks = Task.all.where("status != 'sold' AND status != 'declined' OR status IS NULL").order("created_at DESC")
      filename = 'open'
    end   
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
    if params[:field] == 'status'
      task.update_attribute(params[:field].to_sym, params[:value])
      task.update_attribute(:date, Date.current())
      if params[:value] == 'sold'
        sold_task = current_user.sold_tasks.create(task_id: task.id)
        task.sold_task = sold_task
      elsif SoldTask.exists?(task_id: task.id)
        sold_task = current_user.sold_tasks.find_by(task_id: task.id)
        time = DateTime.now
        comment = "Price: #{sold_task.price} <br> Terms: #{sold_task.date_start} - #{sold_task.date_end}"
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
    tasks = Task.all
    tasks = tasks.where("created_at > '#{params[:period][:from]}'") if !params[:period]["from"].empty?
    tasks = tasks.where("created_at < '#{params[:period][:to]}'") if !params[:period]["to"].empty?
    file_name = 'custom tasks'
    if params[:export]
      case params[:export]
      when 'sold'
        tasks = tasks.where(:status => :sold)
        file_name = 'sold tasks'
      when 'open'
        tasks = tasks.where("status <> 'sold' AND status <> 'declined'")
        file_name = 'open tasks'
        binding.pry
      when 'declined'
        tasks = tasks.where(:status => :declined)
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

  private

    def task_params
      params[:task][:user_id] = current_user.id
      params.require(:task).permit(:name, :source, :skype, :email, :links, :date, :user_id, :status, :comments)
    end
end