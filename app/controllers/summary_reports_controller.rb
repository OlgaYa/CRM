class SummaryReportsController < ApplicationController
  
  def index
    @q = User.reports_oblige_users.ransack(params[:q])
    @users = @q.result
    paginate_users
  end

  

  private

    def paginate_users
      @users = @users.paginate(page: params[:page],
                               per_page: 25)
    end
end
