class ReportsController < ApplicationController
  authorize_resource except: :reports_pointer

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
    @reports = neddfull_reports(date).result
  end

  def new
    @report = Report.new
    @report.date = Date.current
    @user = current_user
  end

  def create
    @report = Report.new(report_params)
    @report.user = current_user
    @report.save
    @reports = neddfull_reports(@report.date).result
  end

  def edit
    @report = Report.find_by_id(params[:id])
    @user = current_user
    render layout: false
  end

  def update
    @report = Report.find_by_id(params[:id])
    @report.update_attributes(report_params)
    @reports = neddfull_reports(@report.date).result
  end

  def destroy
    Report.find(params[:id]).destroy
  end

  def reports_settings
    @settings = {}
    @settings[:visible] = Project.all_exsept_project_current_user (current_user)
    @settings[:invisible] = Project.all_project_current_user (current_user)
    render json: @settings.to_json
  end

  def update_report_settings
    array = params[:invisible].collect{|p| Project.find(p)}
    current_user.projects = array
    redirect_to action: :index
  end

  private

    def report_params
      params.require(:report).permit(:hours, :date, :project_id, :task)
    end

    def date
      if params[:date]
        Date.new(params[:date][:year].to_i, params[:date][:month].to_i)
      else
        Date.current
      end
    end

    def neddfull_reports(date)
      @date = date
      @q = Report.all_in_this_month(date, current_user).ransack(params[:q])
      @q.sorts = ['date desc'] if @q.sorts.empty?
      @q
    end
end
