class ProjectsController < ApplicationController
  def index
    @projects = Project.all_active
  end

  def new
    @project = Project.new
    @colors = YAML.load(File.read(File.join(Rails.root, 'config', 'project.yml'))).to_json
    render layout: false
  end

  def create
    project = Project.create(project_params)
    array_user = params[:user_ids].split(",").map{|u| User.find(u.to_i)}
    project.users = array_user
    redirect_to action: :index
  end

  def edit
    @project = Project.find_by_id(params[:id])
    @colors = YAML.load(File.read(File.join(Rails.root, 'config', 'project.yml'))).to_json
    @project_id = @project.id
    render layout: false
  end

  def update
    project = Project.find(params[:id])
    project.update_attributes(project_params)
    binding.pry
    array_user = params[:user_ids].split(",").map{|u| User.find(u.to_i)}
    project.users = array_user
    redirect_to action: :index
  end

  def destroy
    project = Project.find_by_id(params[:id])
    project.update_attribute(:status, "close")
    redirect_to projects_path
  end

  def users_for_project
   @settings = {}
   unless params[:project_id]
    @settings[:visible] = User.all_users_for_project
   else
    @settings[:visible] = User.all_users_not_for_current_project (params[:project_id].to_i)
    @settings[:invisible] = User.all_users_for_current_project (params[:project_id].to_i)
   end
    render json: @settings.to_json
  end

  private

    def project_params
      params.require(:project).permit(:name, :kind)
    end
end
