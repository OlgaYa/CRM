# Main controller for work with tables
class TablesController < ApplicationController
  load_and_authorize_resource
  include ApplicationHelper

  def index
    case params[:type]
    when 'CANDIDATE'
      @table = Candidate.all
    else
      @table = sale_table
    end
    paginate_table
  end

  def create
    if params[:type] == 'SALE' 
      Sale.create(table_params)
      redirect_to tables_path(only: 'open', type: 'SALE')
    else
      Candidate.create(table_params)
      redirect_to tables_path(type: 'CANDIDATE')
    end
  end

  def update
    Table.find(params[:id]).update_attributes(table_params)
    render json: 'success'.to_json
  end

  def destroy
    Table.find(params[:id]).destroy
  end

  def create_link
    link = Link.create(table_id: params[:table_id],
                       alt: params[:alt],
                       href: params[:href])
    render html: generate_link(link).html_safe
  end

  def destroy_link
    Link.find(params[:id]).destroy
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
