class HistoriesController < ApplicationController
  load_and_authorize_resource
  
  def index
    @type = params[:type]
    @histories = History.history_for_entity(@type, :desc)
    @current_day = Date.today - 1.days
    paginate_history
  end
  
  private

    def paginate_history
      @histories = @histories.paginate(page: params[:page], per_page: 10)
    end
end
