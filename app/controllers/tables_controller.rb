# Main controller for work with tables
class TablesController < ApplicationController
  load_and_authorize_resource
  before_action :nil_if_blank, only: [:download_selective_xls,
                                      :download_scoped_xls]
  before_action :current_entity, only: [:download_selective_xls,
                                        :download_scoped_xls]
  include ApplicationHelper
  
  def index
    case params[:type]
    when 'CANDIDATE'
      @table = Candidate.all
    when 'PLAN'
      @table = Plan.all
    else
      @table = sale_table
    end
    paginate_table
  end

  def create
    if params[:type] == 'SALE'
      object = Sale.create(table_params)
      redirect_to tables_path(only: 'open', type: 'SALE')
    elsif params[:type] == 'PLAN'
      Plan.create(table_params)
      redirect_to tables_path(type: 'PLAN')
    else
      object = Candidate.create(table_params)
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

  def export
  end

  def download_selective_xls
    tables = @entity.export(params[:period][:from],
                            params[:period][:to],
                            params[:users],
                            params[:statuses])
    send_for_user tables
  end

  def download_scoped_xls
    case params[:type]
    when 'SALE'
      tables = scoped_sale_data
    when 'CANDIDATE'
      tables = scoped_candidate_data
    end
    send_for_user tables.in_time_period(params[:period][:from],
                                        params[:period][:to])
  end

  def send_for_user(tables)
    send_data(tables.to_csv({ col_sep: "\t" }, params[:fields]),
              filename: 'data.xls')
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

  def nil_if_blank
    params[:period][:from] = nil if params[:period][:from].blank?
    params[:period][:to] = nil if params[:period][:to].blank?
  end

  def current_entity
    case params[:type]
    when 'SALE'
      @entity = Sale
    when 'CANDIDATE'
      @entity = Candidate
    end
  end

  def scoped_sale_data
    case params[:export]
    when 'sold'
      Sale.sold
    when 'declined'
      Sale.declined
    when 'open'
      Sale.open
    else
      Sale.all
    end
  end

  # NEED WRITE
  def scoped_candidate_data
  end
end
