# Main controller for work with tables
class TablesController < ApplicationController
  include ApplicationHelper
  
  def index
    case params[:type]
    when 'CANDIDATE'
      @table = Candidate.all
    when 'SALE'
      @table = sale_table
    end
    paginate_table
  end

  def create
    if params[:type] == 'SALE' 
      object = Sale.create(table_params)
      redirect_to tables_path(only: 'open', type: 'SALE')
    else
      object = Candidate.create(table_params)
      redirect_to tables_path(type: 'CANDIDATE')
    end
    Statistic.update_statistics(object)
  end

  def update
    Table.find(params[:id]).update_attributes(table_params)
    Statistic.update_statistics(Table.find(params[:id]))
    render json: 'success'.to_json
  end

  def destroy
    Table.find(params[:id]).destroy
  end

  private
    def table_params
      params.require(:table).permit(:type, :name, :level_id,
                                    :specialization_id,
                                    :email, :source_id,
                                    :date, :status_id,
                                    :topic, :skype,
                                    :user_id, :price,
                                    :date_end, :date_start)
    end

   def sale_table
      case params[:only]
      when 'sold'
        Sale.sold
      when 'declined'
        Sale.declined
      else
        Sale.open
      end
    end

    def paginate_table
      @table = @table.paginate(page: params[:page],
                               per_page: 10).oder_date_nulls_first
    end
end
