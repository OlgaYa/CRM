class DesktimeWorker

  include Sidekiq::Worker
  sidekiq_options queue: 'desktime'

  def perform(date)
    DtReport.refresh_month(date)
  end
end
