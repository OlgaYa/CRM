class ProjectReportsController < ApplicationController

  def index
    set_period
    @project_reports = Report.where('date in (?)', @start_date..@finish_date).order(date: :desc, user_id: :asc)
    @summary  = summary
    paginate_project_reports
  end

  def show
    set_period
    @project = Project.find(params[:id])
    @project_reports = Report.where(project: @project).where('date in (?)', @start_date..@finish_date).order(date: :desc, user_id: :asc).paginate(:page => 1, :per_page => 100)
    @summary  = summary
    paginate_project_reports
  end

  private

    def set_period
      @finish_date = Date.today
      @start_date = @finish_date - 7
      unless params[:date].nil?
        begin
          @finish_date = @finish_date.change(year: params[:date][:finish_year].to_i, month: params[:date][:finish_month].to_i, day: params[:date][:finish_day].to_i)
          @start_date = @start_date.change(year: params[:date][:start_year].to_i, month: params[:date][:start_month].to_i, day: params[:date][:start_day].to_i)
        rescue
        end
      end
      @finish_date, @start_date = @start_date, @finish_date if @start_date > @finish_date
    end

    def summary
      user_ids = @project_reports.pluck(:user_id).uniq
      user_ids.map do |user_id|
        { :user_id => user_id, :hours => @project_reports.where(user_id: user_id).sum(:hours) }
      end
    end

    def paginate_project_reports
      @project_reports = @project_reports.paginate(page: params[:page], per_page: 100)
    end

end