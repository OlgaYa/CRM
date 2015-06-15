class SummaryReportsController < ApplicationController
  authorize_resource class: false
  before_action :date, only: [:index, :refresh_dt]

  def index
    @working_hours = (Time.days_in_month(@date.month, @date.year) - Holiday.all.where('date >= ? AND date <= ?', @date.beginning_of_month, @date.end_of_month).count) * 8
    @q = User.reports_oblige_users.ransack(params[:q])
    @q.sorts = ['first_name asc'] if @q.sorts.empty?
    @users = @q.result
    paginate_users
  end

  def refresh_dt
    DesktimeWorker.perform_async(@date)
    render json: 'success'.to_json
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
