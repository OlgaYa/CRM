class TasksController < ApplicationController 
  
  def index
    case params[:only] 
    when 'sold'
      @tasks = Task.all.where("status = 'sold'").order("created_at DESC")
      filename = 'sold'
    when 'declined'
      @tasks = Task.all.where("status = 'declined'").order("created_at DESC")
      filename = 'declined'
    when 'all' 
      @tasks = Task.all.order("created_at DESC")
      filename = 'all'
    else
      @tasks = Task.all.where("status != 'sold' AND status != 'declined' OR status IS NULL").order("created_at DESC")
      filename = 'open'
    end
    
    respond_to do |format|
      format.html
      format.xls { send_data @tasks.to_csv(col_sep: "\t"), :filename =>  filename + ".xls" }
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
      else
        if SoldTask.exists?(task_id: task.id)
          sold_task = current_user.sold_tasks.find_by(task_id: task.id)
          time = DateTime.now
          comment = "Price: #{sold_task.price} <br> Terms: #{sold_task.date_start} - #{sold_task.date_end}"
          task.comments.create(user_id: current_user.id , body: comment, datetime: time)
          sold_task.destroy
        end 
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

  private

    def task_params
      params.require(:task).permit(:name, :source, :skype, :email, :links, :date, :user_id, :status, :comments)
    end
end