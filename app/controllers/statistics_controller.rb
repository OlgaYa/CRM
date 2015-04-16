class StatisticsController < ApplicationController
  respond_to :json

  def index
  end

  def change_information
    @hash = []
    date_from = params[:dateFrom].to_date.at_beginning_of_week
    date_to = params[:dateTo].to_date.at_end_of_week
    allusers, allstatus, allsources = [:users, :status, :sources].collect{|k| params[k].blank? ? [""] : params[k]}

    allsources.each do |x|
        allusers.each do |y|
          allstatus.each do |z|
            name = y.empty? ? "" : "#{User.find_by_id(y).first_name} #{User.find_by_id(y).last_name}"
            select_user = y.empty? ? "" : "user_id = #{y}"
            if name.empty?
              name = x.empty? ? "" : Source.find_by_id(x).name
            else
              name += x.empty? ? "" : ": #{Source.find_by_id(x).name}"
            end
            select_source = x.empty? ? "" : "source_id = #{x}"
            if name.empty?
              name = z.empty? ? "" : Status.find_by_id(z).name
            else
              name += z.empty? ? "" : ": #{Status.find_by_id(z).name}"
            end
            select_status = z.empty? ? "" : "status_id = #{z}"
            name = "All" if name.empty?
            @hash << get_information(name, select_source, select_user, select_status, date_from, date_to)
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

  def get_information(name, source, users, status, date_from, date_to)
    inform = {}
    inform[:name] = name
    inform[:data] = find_in_database(source, users, status, date_from, date_to)
    inform
  end

  def find_in_database(source, users, status, date_from, date_to)
    inform = Statistic.where(source).where(users).where(status).where(:week => date_from..date_to).group(:week).order(:week).sum(:count)
    current_week = date_from
    while current_week < date_to
      inform[current_week] = 0 unless inform.include? (current_week)
      current_week += 1.weeks
    end
    inform.sort.to_a
  end
end
