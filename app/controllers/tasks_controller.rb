class TasksController < ApplicationController 
  
  def index
    @tasks = Task.all.order(:created_at)
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
    redirect_to tasks_path
  end

  def update
    task = Task.find(params[:id])
    if params[:field] == 'status'
      task.update_attribute(params[:field].to_sym, params[:value])
      task.update_attribute(:date, Date.current())
    else    
      task.update_attribute(params[:field].to_sym, params[:value])
    end
    resp = "Success".to_json
    render :json => resp    
  end

  private

    def task_params
      params.require(:task).permit(:name, :source, :skype, :email, :links, :date, :user_id, :status, :comments)
    end
end