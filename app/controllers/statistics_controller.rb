class StatisticsController < ApplicationController
  load_and_authorize_resource
  respond_to :json

  def index
    @type = params[:type]
    @option_for_select = {}
    [:user, :status, :source, :level, :specialization].each do |k|
      @option_for_select[k] = JSON.parse(cookies[k]) if cookies[k] != "null"
    end
    @date_from = cookies[:data_from].to_date
    @date_to = cookies[:date_to].to_date
  end

  def change_information
    @hash = []
    date_from = params[:dateFrom].to_date.at_beginning_of_week
    date_to = params[:dateTo].to_date.at_end_of_week
    allusers, allstatus, allsources, alllevels, allspecializations  = [:user, :status, :source, :level, :specialization].collect do |k|
     cookies[k] = params[k].to_json
     params[k].blank? ? [""] : params[k]
   end
    allsources.each do |source|
        allusers.each do |user|
          allstatus.each do |status|
            alllevels.each do |level|
              allspecializations.each do |specialization|
                name = user.empty? ? "" : User.find_by_id(user).full_name
                select_user = user.empty? ? "" : "user_id = #{user}"
                name = find_name(name, "source", source)
                select_source = source.empty? ? "" : "source_id = #{source}"
                name = find_name(name, "level", level)
                select_level = level.empty? ? "" : "level_id = #{level}"
                name = find_name(name, "specialization", specialization)
                select_specialization = specialization.empty? ? "" : "specialization_id = #{specialization}"
                name = find_name(name, "status", status)
                select_status = status.empty? ? "status_id = #{Status.default_status(params[:type])}" : "status_id = #{status}"
                name = "All" if name.empty?
                @hash << get_information(name, select_source, select_user, select_status, select_level, select_specialization, date_from, date_to)
              end
            end
          end
        end
      end

    @hash = @hash.to_json
    @date_start = date_from.to_datetime.to_i * 1000
    @date_interval = 7 * 24 * 3600 * 1000

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  private

    def get_information(name,
                        source,
                        users,
                        status,
                        level,
                        specialization,
                        date_from,
                        date_to)

      inform = {}
      inform[:name] = name
      inform[:data] = find_in_database(source,
                                       users,
                                       status,
                                       level,
                                       specialization,
                                       date_from,
                                       date_to)
      inform
    end

    def find_in_database(source,
                         users,
                         status,
                         level,
                         specialization,
                         date_from,
                         date_to)

      inform = Statistic.where(source
                              ).where(users
                              ).where(status
                              ).where(level
                              ).where(specialization
                              ).where(week: date_from..date_to
                              ).group(:week
                              ).order(:week
                              ).sum(:count)
                              
      current_week = date_from
      while current_week < date_to
        inform[current_week] = 0 unless inform.include?(current_week)
        current_week += 1.weeks
      end
      inform.sort.to_a
    end

    def find_name(name, name_class, id)
      name += if name.empty?
        id.empty? ? '' : name(name_class, id)
      else
        id.empty? ? '' : ": #{name(name_class, id)}"
      end
    end

    def name(name_class, id)
      name_class.singularize.capitalize.constantize.find_by_id(id).name
    end
end
