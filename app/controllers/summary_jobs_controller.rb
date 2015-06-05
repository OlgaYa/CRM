class SummaryJobsController < ApplicationController

  def index
    @users = User.includes(:projects).summary_job
  end

end