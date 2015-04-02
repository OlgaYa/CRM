# Main controller for work with tables
class TablesController < ApplicationController
  def index
    case params[:type]
    when 'CANDIDATE'
      @table = Candidate.all
    when 'SALE'
      @table = sale_table
    end
  end

  def create
    Table.create(table_params)
  end

  def update
    Table.update_attributes(table_params)
  end

  def destroy
    Table.find(params[:id]).destroy
  end

  private def table_params
    params.require(:table).permit(:type, :name, :level_id,
                                  :specialization_id,
                                  :email, :source_id,
                                  :date, :status_id,
                                  :topic, :skype,
                                  :user_id, :price,
                                  :date_end, :date_start)
  end

  private def sale_table
    case params[:only]
    when 'sold'
      Sale.sold
    when 'declined'
      Sale.declined
    else
      Sale.open
    end
  end
end
