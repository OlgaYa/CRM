class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :current_entity, only: :create
  before_action :current_table_settings, only: :create

  include ApplicationHelper
  include PrepareTableForDraw

  def create
    table = Table.find(params[:table_id])
    time = DateTime.now
    comment = table.comments.create(user_id: current_user.id,
                                    body: params[:body],
                                    datetime: time)
    update_table_date table
    History.create_history_for_update_object(table, { "Comment"=>comment.id })
    render json: { comment: generate_comment(comment, time).html_safe,
                   table: @table_page }.to_json
  end

  def destroy
    @comment.destroy
  end

  private

    def update_table_date(table)
      table.update_attribute(:date, DateTime.now)
      @q = q_sort
      @table = @q.result.oder_date_nulls_first
      paginate_table if need_paginate?
      @table_page = view_context.render 'tables/table_body'
    end
end
