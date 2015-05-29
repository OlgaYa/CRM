class ReportsController < ApplicationController
  load_and_authorize_resource except: :reports_pointer
  before_action :date, only: :index

  def reports_pointer
    if can? :index, :summary_report
      redirect_to summary_reports_path
    elsif can? :all_reports, :reports
      redirect_to all_reports_path
    elsif can? :index, Report
      redirect_to reports_path
    end
  end


  def index
    @q = Report.all_in_this_month(@date, params[:q], current_user)
    @q.sorts = ['date desc'] if @q.sorts.empty?
    @reports = @q.result
    @report = Report.new
  end

  def new
    @report = Report.new
  end

  def create
    report = Report.new(report_params)
    report.user = current_user
    report.save
    redirect_to :back
  end

  def edit
    @report = Report.find_by_id(params[:id])
  end

  def update
    report = Report.find_by_id(params[:id])
    report.update_attributes(report_params)
    redirect_to :back
  end

  def delete
  end

  private

    def report_params
      params.require(:report).permit(:hours, :date, :project, :task)
    end

    def date
      if params[:date]
        @date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i)
      else
        @date = Date.current
      end
    end
end
