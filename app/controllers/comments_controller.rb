class CommentsController < ApplicationController

  include ApplicationHelper

  def create
    task = Task.find(params[:task_id])
    time = DateTime.now
    comment = task.comments.create(user_id: current_user.id , body: params[:body], datetime: time) 
    task.update_attribute(:date, Date.current())
    render html: generate_comment(comment, time).html_safe
  end

  def destroy
    Comment.find(params[:id]).destroy
  end
end
