# Main controller for work with tables
class TablesController < ApplicationController
  load_and_authorize_resource
  before_action :nil_if_blank, only: [:download_selective_xls,
                                      :download_scoped_xls]
  before_action :current_entity, only: [:download_selective_xls,
                                        :download_scoped_xls]
  after_action :send_remind_today, only: :update
  include ApplicationHelper
  
  def index
    @q = case params[:type]
         when 'CANDIDATE'
           candidate_table
         when 'SALE'
           sale_table
         end.ransack(params[:q])
    @table = @q.result.includes(:source, :status)
    paginate_table
  end

  def create
    case params[:type]
    when 'SALE'
      object = Sale.create(table_params)
      redirect_to tables_path(only: 'open', type: 'SALE')
    when 'CANDIDATE'
      object = Candidate.create(table_params)
      redirect_to tables_path(type: 'CANDIDATE')
    end
    Statistic.update_statistics(object)
  end

  def update
    table = Table.find(params[:id])
    table.update_attributes(table_params)
    Statistic.update_statistics(table)
    if not_itself_id?(params[:table][:user_id])
      UserMailer.new_assign_user_instructions(table,
                                              current_user,
                                              params[:table][:user_id].to_i)
        .deliver
    end
    render json: 'success'.to_json
  end

  def destroy
    table = Table.find(params[:id])
    Statistic.destroy(table)
    table.destroy
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
    tables = case params[:type]
             when 'SALE'
               scoped_sale_data
             when 'CANDIDATE'
               scoped_candidate_data
             end
    send_for_user tables.in_time_period(params[:period][:from],
                                        params[:period][:to])
  end

  def send_for_user(tables)
    send_data(tables.to_csv({ col_sep: "\t" }, params[:fields]),
              filename: 'data.xls')
  end

  # CAN BE USEFUL IN FUTURE
  def json_filters
    render json: case params[:type]
                 when 'SALE'
                   Sale.simple_filters
                 when 'CANDIDATE'
                   Candidate.simple_filters
                 end.to_json
  end

  private

    def table_params
      params.require(:table).permit(:type, :name, :level_id,
                                    :specialization_id,
                                    :email, :source_id,
                                    :date, :status_id,
                                    :topic, :skype,
                                    :user_id, :price,
                                    :date_end, :date_start,
                                    :reminder_date)
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

    def candidate_table
      case params[:only]
      when 'hired'
        Candidate.hired
      when 'we_declined'
        Candidate.we_declined
      when 'he_declined'
        Candidate.he_declined
      when 'contact_later'
        Candidate.contact_later
      else
        Candidate.open
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

    # NEED OPIMIZE
    def send_remind_today
      return unless params[:table][:status_id] && Status.find(params[:table][:status_id]).contact_later? 
      table = Table.find(params[:id])
      reminder_date = table.reminder_date
      return unless reminder_date.to_date == Date.today && reminder_date > DateTime.current
      UserMailer.remind_today(table.id)
        .deliver_later(wait_until: reminder_date)
    end

    def not_itself_id?(id)
      return false unless id
      current_user.id != id.to_i
    end
end
