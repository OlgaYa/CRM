# This file is called comments_controller.rb
# It contains the class CommentsController
class CommentsController < ApplicationController
  include ApplicationHelper

  def create
    task = Task.find(params[:task_id])
    time = DateTime.now
    comment = task.comments.create(user_id: current_user.id,
                                   body: params[:body],
                                   datetime: time)
    ubdate_task_date task
    render html: generate_comment(comment, time).html_safe
  end

  def destroy
    Comment.find(params[:id]).destroy
  end

  private def ubdate_task_date(task)
    task.update_attribute(:date, Date.current)
  end
end
