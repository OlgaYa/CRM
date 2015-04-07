# This file is called comments_controller.rb
# It contains the class CommentsController
class CommentsController < ApplicationController
  include ApplicationHelper

  def create
    table = Table.find(params[:table_id])
    time = DateTime.now
    comment = table.comments.create(user_id: current_user.id,
                                    body: params[:body],
                                    datetime: time)
    ubdate_table_date table
    render html: generate_comment(comment, time).html_safe
  end

  def destroy
    Comment.find(params[:id]).destroy
  end

  private 

    def ubdate_table_date(table)
      table.update_attribute(:date, Date.current)
    end
end
