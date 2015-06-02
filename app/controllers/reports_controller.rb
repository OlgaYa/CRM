class ReportsController < ApplicationController

  def index
    @date = params[:date_report] ? Date.strptime(params[:date_report], "%m/%Y") : Date.today
    @q = Report.all_in_this_month(@date, params[:q], current_user)
    @reports = @q.result.order('date DESC')
  end

  def new
    @report = Report.new
    @user = current_user
    render layout: false
  end

  def create
    report = Report.new(report_params)
    report.user = current_user
    report.save
    redirect_to action: :index
  end

  def edit
    @report = Report.find_by_id(params[:id])
    @user = current_user
    render layout: false
  end

  def update
    report = Report.find_by_id(params[:id])
    report.update_attributes(report_params)
    redirect_to action: :index
  end

  def delete
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
end
