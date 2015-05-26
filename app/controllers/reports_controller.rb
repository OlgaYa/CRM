class ReportsController < ApplicationController

  def index
    @date = params[:date_report] ? Date.strptime(params[:date_report], "%m/%Y") : Date.today

    @q = Report.all_in_this_month(@date, params[:q], current_user)
    @reports = @q.result.order('date DESC')
    @report = Report.new
  end

  def create
    report = Report.new(report_params)
    report.user = current_user
    report.save
    redirect_to action: :index
  end

  def edit
    @report = Report.find_by_id(params[:id])
    render layout: false
  end

  def update
    report = Report.find_by_id(params[:id])
    report.update_attributes(report_params)
    redirect_to action: :index
  end

  def delete
  end

  private

    def report_params
      params.require(:report).permit(:hours, :date, :project, :task)
    end
end
