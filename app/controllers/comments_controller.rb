class CommentsController < ApplicationController

  def create

  end

  def destroy
    if Comment.find(params[:id]).destroy
    else
    end
  end
end
