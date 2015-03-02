class CommentsController < ApplicationController

  def create
    task = Task.find(params[:task_id])
    time = DateTime.current()
    comment = task.comments.create(user_id: current_user.id , body: params[:body], datetime: time)
    resp = "<div class='comment " + comment.id.to_s +
            "'><span class='comment_time'>" + time.strftime("%e.%m %H:%M") +
            " </span><span>" + current_user.first_name +
            " </span> <a class='pull-right' data-remote='true'"+
            " rel='nofollow' data-method='delete' href='"+ comment_path(comment) + 
            "'><img src='#{ActionController::Base.helpers.asset_path("remove-red.png")}' ></a> <p>" + params[:body] +
            "</p></div>"
    task.update_attribute(:date, Date.current())
    render :html => resp.html_safe
  end

  def destroy
    Comment.find(params[:id]).destroy
  end
end
