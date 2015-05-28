class ProjectsController < ApplicationController
  def index
    @projects = Project.all_active
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
