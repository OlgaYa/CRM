module PrepareTableForDraw
  def q_sort
    case params[:type]
    when 'CANDIDATE'
      candidate_table
    when 'SALE'
      sale_table
    end.ransack(params[:q])
  end

  def current_entity
    case params[:type]
    when 'SALE'
      @entity = Sale
    when 'CANDIDATE'
      @entity = Candidate
    end
  end

  def current_table_settings
    @settings = {}
    all_fields = default_table_settings
    if current_user.table_settings
      hidden_fields =  JSON.parse(current_user.table_settings)[current_key]
      hidden_fields.map! { |f| f.to_sym } if hidden_fields
      @settings[:visible] = hidden_fields ? all_fields - hidden_fields : all_fields
      @settings[:invisible] = hidden_fields
    else
      @settings[:visible] = all_fields
    end
    @settings
  end

  def default_table_settings
    if %w(sold contact_later).include? params[:only]
      @entity.ADVANCED_COLUMNS
    else
      @entity.DEFAULT_COLUMNS
    end
  end

  def user_table_settings
    current_user.table_settings[current_key]
  end

  def current_key
    if %w(sold contact_later).include? params[:only]
      key = 'ADVANCED_' + params[:type]
    else
      key = 'DEFAULT_' + params[:type]
    end
    key
  end

  def ubdate_table_date(table)
    table.update_attribute(:date, Date.current)
    @q = case params[:type]
         when 'CANDIDATE'
           candidate_table
         when 'SALE'
           sale_table
         end.ransack(params[:q])
    @table = @q.result.oder_date_nulls_first
    paginate_table if need_paginate?
    render partial: 'tables/table'
  end

  def sale_table
    only = params[:only].to_sym
    if %i(sold decline).include? only
      Sale.public_send only
    else
      Sale.open
    end
  end

  def candidate_table
    only = params[:only].to_sym
    if %i(hired we_declined he_declined contact_later).include? only
      Candidate.public_send only
    else
      Candidate.open
    end
  end

  def paginate_table
    @table = @table.oder_date_nulls_first
    @table = @table.paginate(page: params[:page],
                             per_page: cookies[:lid_count] ||= 25)
  end

  def need_paginate?
    cookies[:lid_count].to_sym != :all
  end

  def lid_count_conf
    return unless params[:lid_count]
    cookies[:lid_count] = params[:lid_count]
  end

  def not_itself_id?(id)
    return false unless id
    current_user.id != id.to_i
  end
end
