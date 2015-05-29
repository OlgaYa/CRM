class SummaryReportsController < ApplicationController
  authorize_resource class: false
  before_action :date, only: [:index, :refresh_dt]

  def index
    @q = User.reports_oblige_users.ransack(params[:q])
    @q.sorts = ['first_name asc'] if @q.sorts.empty?
    @users = @q.result
    paginate_users
  end

  def refresh_dt
    DtReport.refresh_month(@date)
    redirect_to :back
  end

  private

    def date
      if params[:date]
        @date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i)
      else
        @date = Date.current
      end
    end

    def paginate_users
      @users.paginate(page: params[:page], per_page: 25)
    end
end
