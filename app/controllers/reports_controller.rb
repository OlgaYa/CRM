class ReportsController < ApplicationController

  def index
    @date = params[:date_report] ? Date.strptime(params[:date_report], "%m/%Y") : Date.today

    @q = Report.where(user: current_user,
                            :date => @date.beginning_of_month..@date.end_of_month).ransack(params[:q])
    @reports = @q.result.order('date DESC')
    @report = Report.new
  end

  def create
    report = Report.new(report_params)
    report.user = current_user
    if report.save
      redirect_to action: :index
    else
      redirect_to action: :index
    end
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
