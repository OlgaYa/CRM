class LinksController < ApplicationController

  include ApplicationHelper

  def create
    link = Link.create(task_id: params[:task_id] , alt: params[:alt], href: params[:href])  
    render html: generate_link(link).html_safe
  end

  def destroy
    Link.find(params[:id]).destroy
  end
end
